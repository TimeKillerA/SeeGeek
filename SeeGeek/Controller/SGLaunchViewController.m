//
//  SGLaunchViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGLaunchViewController.h"
#import "../Macro/SGViewControllerHeader.h"
#import "../Protocol/SGViewControllerDelegate.h"
#import "SGLaunchViewModelProtocol.h"
#import <MSWeakTimer.h>
#import <objc/runtime.h>

#import "SGVideoConfigration.h"
#import "SGAudioConfigration.h"
#import "SGStreamConfigration.h"
#import "SGCameraDevice.h"

#define OBJC_ASSOCIATED(property, setProperty) \
-(id)property {\
    return objc_getAssociatedObject(self, @selector(property));\
}\
- (void)setProperty:(id)property {\
    objc_setAssociatedObject(self, @selector(property), property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}



NSInteger const DEFAULT_DISPATCH_TIME_TO_NEXT = 3;

@interface SGLaunchViewController (Test)<SGCameraDeviceDelegate>

@property (nonatomic, strong)SGCameraDevice *cameraDevice;
@property (nonatomic, strong)SGVideoConfigration *videoConfigrarion;
@property (nonatomic, strong)SGAudioConfigration *audioConfigration;
@property (nonatomic, strong)SGStreamConfigration *streamConfigration;
@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UIButton *flashButton;
@property (nonatomic, strong)UIButton *frontCameraButton;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong)UIView *containerView;

@end

@implementation SGLaunchViewController (Test)

OBJC_ASSOCIATED(cameraDevice,       setCameraDevice)
OBJC_ASSOCIATED(videoConfigrarion,  setVideoConfigrarion)
OBJC_ASSOCIATED(audioConfigration,  setAudioConfigration)
OBJC_ASSOCIATED(streamConfigration, setStreamConfigration)
OBJC_ASSOCIATED(flashButton,        setFlashButton)
OBJC_ASSOCIATED(frontCameraButton,  setFrontCameraButton)
OBJC_ASSOCIATED(previewLayer,       setPreviewLayer)
OBJC_ASSOCIATED(containerView,      setContainerView)
OBJC_ASSOCIATED(startButton,        setStartButton)

- (void)initProperties {
    self.videoConfigrarion = [[SGVideoConfigration alloc] init];
    self.audioConfigration = [[SGAudioConfigration alloc] init];
    self.streamConfigration = [[SGStreamConfigration alloc] initWithHost:@"rtmp://115.29.39.174:1935" source:@"live" title:@"myStream"];
    self.cameraDevice = [[SGCameraDevice alloc] initWithVideoConfigration:self.videoConfigrarion audioConfigration:self.audioConfigration streamConfigration:self.streamConfigration];
    self.cameraDevice.delegate = self;
    self.containerView = [[UIView alloc] init];
    self.frontCameraButton = [[UIButton alloc] init];
    self.flashButton = [[UIButton alloc] init];
    self.startButton = [[UIButton alloc] init];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.flashButton];
    [self.containerView addSubview:self.frontCameraButton];
    [self.containerView addSubview:self.startButton];
    [self updateConstraints];
    [self initButtonEvent];
}

- (void)updateConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(self.containerView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.startButton);
        make.right.mas_equalTo(self.startButton.mas_left).offset(-10);
    }];
    [self.frontCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.startButton);
        make.left.mas_equalTo(self.startButton.mas_right).offset(10);
    }];
}

- (void)initButtonEvent {
    WS(weakSelf);
    [[self.startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(weakSelf.cameraDevice.isPublishStart) {
            [weakSelf.cameraDevice stopPublish];
        } else {
            [weakSelf.cameraDevice startPublish];
        }
    }];
    [[self.flashButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.cameraDevice.flashOn = !weakSelf.cameraDevice.flashOn;
    }];
    [[self.frontCameraButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.cameraDevice.frontCamera = !weakSelf.cameraDevice.frontCamera;
    }];
    [RACObserve(self.cameraDevice, isPublishStart) subscribeNext:^(id x) {
        if([x boolValue]) {
            [weakSelf.startButton setTitle:@"停止" forState:UIControlStateNormal];
            weakSelf.startButton.backgroundColor = [UIColor redColor];
        } else {
            [weakSelf.startButton setTitle:@"开始" forState:UIControlStateNormal];
            weakSelf.startButton.backgroundColor = [UIColor blueColor];
        }
    }];
    [RACObserve(self.cameraDevice, flashOn) subscribeNext:^(id x) {
        if([x boolValue]) {
            [weakSelf.flashButton setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
            weakSelf.flashButton.backgroundColor = [UIColor redColor];
        } else {
            [weakSelf.flashButton setTitle:@"打开闪光灯" forState:UIControlStateNormal];
            weakSelf.flashButton.backgroundColor = [UIColor blueColor];
        }
    }];
    [RACObserve(self.cameraDevice, frontCamera) subscribeNext:^(id x) {
        if([x boolValue]) {
            [weakSelf.frontCameraButton setTitle:@"后置摄像头" forState:UIControlStateNormal];
            weakSelf.frontCameraButton.backgroundColor = [UIColor redColor];
        } else {
            [weakSelf.frontCameraButton setTitle:@"前置摄像头" forState:UIControlStateNormal];
            weakSelf.frontCameraButton.backgroundColor = [UIColor blueColor];
        }
    }];
}

#pragma mark - SGCameraDeviceDelegate
- (void)cameraDevice:(SGCameraDevice *)cameraDevice
        previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer {
    [previewLayer removeFromSuperlayer];
    previewLayer.frame = self.containerView.bounds;
    [[previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [self.containerView.layer addSublayer:previewLayer];
    self.previewLayer = previewLayer;
}

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
   didRecordComplete:(NSURL *)fileURL {

}

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
     didRecordFailed:(NSError *)error {

}

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
       publishFailed:(NSError *)error {

}

@end

@interface SGLaunchViewController ()<SGViewControllerDelegate>

@property (nonatomic, strong)id<SGLaunchViewModelProtocol> viewModel;
@property (nonatomic, strong)MSWeakTimer *weakTimer;

@end

@implementation SGLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAdData];
    [self dispatchToNextPageAfter:DEFAULT_DISPATCH_TIME_TO_NEXT];
    [self initProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - private method

/**
 *  下载广告数据
 */
- (void)loadAdData {
    if(![self.viewModel respondsToSelector:@selector(signalForLoadData)]) {
        DDLogError(@"ERROR %@'S viewModel CAN NOT RESPONDS signalForLoadData", self);
        return;
    }
    WS(weakSelf);
    [[[self.viewModel signalForLoadData] deliverOnMainThread] subscribeError:^(NSError *error) {
        DDLogWarn(@"WARNNING loadAdData FAILED ERROR:%@", error);
    } completed:^{
        [weakSelf destroyTimer];
        [weakSelf showAdIfNeed];
    }];
}

- (void)dispatchToNextPageAfter:(NSTimeInterval)seconds {
    self.weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:seconds target:self.viewModel selector:@selector(dispatchToNextPage) userInfo:nil repeats:NO dispatchQueue:dispatch_get_main_queue()];
}

- (void)destroyTimer {
    [self.weakTimer invalidate];
    self.weakTimer = nil;
}

- (void)showAdIfNeed {

}

@end
