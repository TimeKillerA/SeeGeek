//
//  SGAVPublisher.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGAVPublisher.h"
#import <rtmp.h>
#import "SGStreamConfigration.h"
#import "NSError+Constructor.h"
#import "SGEncodedFrame.h"

#define RTMP_HEAD_SIZE   (sizeof(RTMPPacket)+RTMP_MAX_HEADER_SIZE)
#define KEY_FRAME_ID 5

@interface SGAVPublisher ()

@property (nonatomic, assign)RTMP *rtmp;
@property (nonatomic, strong)dispatch_queue_t sendQueue;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)long initTimestamp;
@property (nonatomic, strong)SGStreamConfigration *streamConfigration;
@property (nonatomic, assign)BOOL isConnected;
@property (nonatomic, assign)BOOL isStarted;
@property (nonatomic, strong)SGEncodedFrame *spsFrame;
@property (nonatomic, strong)SGEncodedFrame *ppsFrame;

@end

@implementation SGAVPublisher

#pragma mark - life cycle
- (void)dealloc {
    [self stopPublish];
}

#pragma mark - public method
- (void)updateStreamConfigration:(SGStreamConfigration *)streamConfigration {
    self.streamConfigration = streamConfigration;
    [self disConnect];
    [self connect];
}

- (void)startPublish {
    if(self.isStarted) {
        return;
    }
    if(!self.isConnected) {
        [self connect];
    }
    WS(weakSelf);
    self.isStarted = YES;
    dispatch_async(self.sendQueue, ^{
        [weakSelf run];
    });
}

- (void)stopPublish {
    self.isStarted = NO;
    [self disConnect];
    [self resetData];
}

- (void)publishFrame:(SGEncodedFrame *)frame {
    @synchronized(self.dataArray) {
        [self.dataArray addObject:frame];
    }
}

#pragma mark - help
- (void)connect {
    NSError *error = nil;
    do {
        if(!self.streamConfigration) {
            DDLogWarn(@"streamConfigration can not be null");
            error = [NSError errorWithCode:-1 message:@"streamConfigration can not be null"];
            break;
        }
        self.rtmp = RTMP_Alloc();
        RTMP_Init(self.rtmp);
        char *url = (char *)[[self.streamConfigration streamUrl] cStringUsingEncoding:NSUTF8StringEncoding];
        if(RTMP_SetupURL(self.rtmp, url) == FALSE) {
            DDLogWarn(@"setup rtmp url failed %@", [self.streamConfigration streamUrl]);
            error = [NSError errorWithCode:-1 message:@"setup rtmp url failed"];
            break;
        }
        RTMP_EnableWrite(self.rtmp);
        if(RTMP_Connect(self.rtmp, NULL) == FALSE){
            DDLogWarn(@"ERROR! connect rtmp server failed");
            error = [NSError errorWithCode:-1 message:@"connect rtmp server failed"];
            break;
        }
        if(RTMP_ConnectStream(self.rtmp, 0) == FALSE)
        {
            DDLogWarn(@"ERROR! connect rtmp stream failed");
            error = [NSError errorWithCode:-1 message:@"connect rtmp stream failed"];
            break;
        }
        self.initTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        self.isConnected = YES;
        return;
    } while (NO);
    self.isConnected = NO;
    [self disConnect];
    [self notifyConnectError:error];
}

- (void)disConnect {
    if(self.rtmp) {
        RTMP_Close(_rtmp);
        RTMP_Free(_rtmp);
        _rtmp = NULL;
    }
    self.isConnected = NO;
}

- (void)run {
    if(!self.isStarted) {
        return;
    }
    NSTimeInterval sleepTime = 0.1;
    do {
        if([self.dataArray count] == 0) {
            break;
        }
        @synchronized(self.dataArray) {
            if([self.dataArray count] == 0) {
                break;
            }
            sleepTime = 0.005;
            SGEncodedFrame *frame = [self.dataArray objectAtIndex:0];
            [self sendData:frame];
            [self.dataArray removeObjectAtIndex:0];
        }

    } while (NO);
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sleepTime * NSEC_PER_SEC)), self.sendQueue, ^{
        [weakSelf run];
    });
}

- (void)sendData:(SGEncodedFrame *)frame {
    if(!self.isStarted) {
        return;
    }
    NSError *error = nil;
    @synchronized(frame) {
        switch (frame.type) {
            case SGEncodedFrameTypeVideoPPS:
                self.ppsFrame = frame;
                error = [self sendPPSSPS];
                break;
            case SGEncodedFrameTypeVideoSPS:
                self.spsFrame = frame;
                break;
            case SGEncodedFrameTypeAudioBody:
                error = [self sendAAC:frame];
                break;
            case SGEncodedFrameTypeVideoData:
                error = [self sendH264:frame];
                break;
            case SGEncodedFrameTypeAudioHeader:
                error = [self sendAACHeader:frame];
                break;
            default:
                break;
        }
    }
    [self notifySendDataComplete:frame error:error];
}

- (void)resetData {
    @synchronized(self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    self.initTimestamp = 0;
}

- (void)notifyConnectError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(publisher:connectFailed:)]) {
        [self.delegate publisher:self connectFailed:error];
    }
}

- (void)notifySendDataComplete:(SGEncodedFrame *)frame error:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(publisher:didSendFrame:error:)]) {
        [self.delegate publisher:self didSendFrame:frame error:error];
    }
}

#pragma mark - send data
- (NSError *)sendPPSSPS {
    if(self.spsFrame == nil || self.ppsFrame == nil){
        return nil;
    }
    NSData *spsData = self.spsFrame.data;
    NSData *ppsData = self.ppsFrame.data;
    int sps_len = (int)[spsData length];
    int pps_len = (int)[ppsData length];
    const char *sps = [spsData bytes];
    const char *pps = [ppsData bytes];
    char body[1024];
    int totalLength = 0;

    body[totalLength++] = 0x17;
    body[totalLength++] = 0x00;

    body[totalLength++] = 0x00;
    body[totalLength++] = 0x00;
    body[totalLength++] = 0x00;

    /*AVCDecoderConfigurationRecord*/
    body[totalLength++] = 0x01;
    body[totalLength++] = sps[1];
    body[totalLength++] = sps[2];
    body[totalLength++] = sps[3];
    body[totalLength++] = 0xff;

    /*sps*/
    body[totalLength++]   = 0xe1;
    body[totalLength++] = (sps_len >> 8) & 0xff;
    body[totalLength++] = sps_len & 0xff;
    memcpy(&body[totalLength],sps,sps_len);
    totalLength +=  sps_len;

    /*pps*/
    body[totalLength++]   = 0x01;
    body[totalLength++] = (pps_len >> 8) & 0xff;
    body[totalLength++] = (pps_len) & 0xff;
    memcpy(&body[totalLength],pps,pps_len);
    totalLength +=  pps_len;

    return [self sendPacketType:RTMP_PACKET_TYPE_VIDEO size:totalLength timestamp:0 data:body];
}

- (NSError *)sendH264:(SGEncodedFrame *)frame {
    int len = (int)[frame.data length];
    const char *buf = [frame.data bytes];
    int type;
    char body[len + 9];

    /*去掉帧界定符*/
    if (buf[2] == 0x00) { /*00 00 00 01*/
        buf += 4;
        len -= 4;
    } else if (buf[2] == 0x01){ /*00 00 01*/
        buf += 3;
        len -= 3;
    }
    type = buf[0]&0x1f;

    /*send video packet*/
    memset(body,0,len+9);

    /*key frame*/
    body[0] = 0x27;
    if (type == KEY_FRAME_ID) {
        body[0] = 0x17;
        [self sendPPSSPS];
    }

    body[1] = 0x01;   /*nal unit*/
    body[2] = 0x00;
    body[3] = 0x00;
    body[4] = 0x00;

    body[5] = (len >> 24) & 0xff;
    body[6] = (len >> 16) & 0xff;
    body[7] = (len >>  8) & 0xff;
    body[8] = (len ) & 0xff;

    /*copy data*/
    memcpy(&body[9],buf,len);
    return [self sendPacketType:RTMP_PACKET_TYPE_VIDEO size:len + 9 timestamp:([[NSDate date] timeIntervalSince1970]*1000 - self.initTimestamp) data:body];
}

- (NSError *)sendAACHeader:(SGEncodedFrame *)frame {
//    char *body = (char *)[frame.data bytes];
    char body[] = {0xaf, 0x00, 0x12, 0x10};
    return [self sendPacketType:RTMP_PACKET_TYPE_AUDIO size:[frame.data length] timestamp:0 data:body];
}

- (NSError *)sendAAC:(SGEncodedFrame *)frame {
    const char *buf = [frame.data bytes];
    int len = (int)[frame.data length];
    char body[len+2];

    /*AF 01 + AAC RAW data*/
    body[0] = 0xAF;
    body[1] = 0x01;
    memcpy(&body[2],buf,len);

    return [self sendPacketType:RTMP_PACKET_TYPE_AUDIO size:len + 2 timestamp:([[NSDate date] timeIntervalSince1970]*1000 - self.initTimestamp) data:body];
}

- (NSError *)sendPacketType:(uint8_t)type
                       size:(NSInteger)size
                  timestamp:(long)timeStamp
                       data:(char *)data {
    RTMPPacket *packet = (RTMPPacket *)malloc(RTMP_HEAD_SIZE+size);;
    memset(packet,0,RTMP_HEAD_SIZE+size);
    packet->m_body = (char *)packet + RTMP_HEAD_SIZE;
    packet->m_hasAbsTimestamp = 0;
    packet->m_packetType = type;
    packet->m_nInfoField2 = self.rtmp->m_stream_id;
    packet->m_nChannel = 0x04;
    packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
    packet->m_nTimeStamp = (uint32_t)timeStamp;
    packet->m_nBodySize = (uint32_t)size;
    memcpy(packet->m_body, data, size);
    NSError *error;
    if(RTMP_SendPacket(self.rtmp,packet,TRUE) == FALSE) {
        error = [NSError errorWithCode:-1 message:@"SEND PACKET FAILED"];
        DDLogWarn(@"SEND PACKET FAILED type:%d, timestamp:%ld", type, timeStamp);
    } else {
        error = nil;
    }
    free(packet);
    return error;
}

#pragma mark - accessory
- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (dispatch_queue_t)sendQueue {
    if(!_sendQueue) {
        _sendQueue = dispatch_queue_create("SG.queue.send", NULL);
    }
    return _sendQueue;
}

@end
