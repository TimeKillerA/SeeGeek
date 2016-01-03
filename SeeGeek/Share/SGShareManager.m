//
//  SGShareManager.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import <WXApi.h>

//新浪微博SDK头文件
#import <WeiboSDK.h>

static NSString *const SHARE_SDK_APP_KEY = @"e2832a200329";

#pragma mark - sina
static NSString *const SINA_APP_KEY = @"";
static NSString *const SINA_APP_SECRET = @"";
static NSString *const SINA_APP_REDIRECT_URL = @"";

#pragma mark - qq
static NSString *const QQ_APP_KEY = @"";
static NSString *const QQ_APP_SECRET = @"";

#pragma mark - wechat
static NSString *const WECHAT_APP_KEY = @"";
static NSString *const WECHAT_APP_SECRET = @"";

@implementation SGShareManager

+ (void)load {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SGShareManager setupShareSDK];
    });
}

+ (void)setupShareSDK {
    [ShareSDK registerApp:SHARE_SDK_APP_KEY

          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 [appInfo SSDKSetupSinaWeiboByAppKey:SINA_APP_KEY
                                           appSecret:SINA_APP_SECRET
                                         redirectUri:SINA_APP_REDIRECT_URL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WECHAT_APP_KEY
                                       appSecret:WECHAT_APP_SECRET];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_APP_KEY
                                      appKey:QQ_APP_SECRET
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

+ (void)shareWithTitle:(NSString *)title
               content:(NSString *)content
              imageUrl:(NSString *)imageUrl
           redirectUrl:(NSString *)redirectUrl
         thirdpartType:(SGThirdPartType)type
              callback:(SGShareComplete)callback {
    [ShareSDK share:[SGShareManager SSDKPlatformTypeForSGThirdPartType:type] parameters:[SGShareManager shareParamsWithTitle:title content:content imageUrl:imageUrl redirectUrl:redirectUrl type:[SGShareManager SSDKPlatformTypeForSGThirdPartType:type]] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if(!callback) {
            return;
        }
        switch (state) {
            case SSDKResponseStateBegin: {
                break;
            }
            case SSDKResponseStateSuccess: {
                callback(nil);
                break;
            }
            case SSDKResponseStateFail: {
                callback(error);
                break;
            }
            case SSDKResponseStateCancel: {
                callback(error);
                break;
            }
        }
    }];
}

+ (SSDKPlatformType)SSDKPlatformTypeForSGThirdPartType:(SGThirdPartType)type {
    switch (type) {
        case SGThirdPartTypeNone: {
            return SSDKPlatformTypeUnknown;
        }
        case SGThirdPartTypeShareQZone: {
            return SSDKPlatformSubTypeQZone;
        }
        case SGThirdPartTypeShareQQMessage: {
            return SSDKPlatformSubTypeQQFriend;
        }
        case SGThirdPartTypeShareWechatTimeline: {
            return SSDKPlatformSubTypeWechatTimeline;
        }
        case SGThirdPartTypeShareWechatMessage: {
            return SSDKPlatformSubTypeWechatSession;
        }
        case SGThirdPartTypeShareSina: {
            return SSDKPlatformTypeSinaWeibo;
        }
        case SGThirdPartTypeShareCopy: {
            return SSDKPlatformTypeCopy;
        }
        default:
            return SSDKPlatformTypeUnknown;
    }
}

+ (NSMutableDictionary *)shareParamsWithTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl redirectUrl:(NSString *)redirectUrl type:(SSDKPlatformType)type {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    switch (type) {
        case SSDKPlatformTypeSinaWeibo: {
            break;
        }
        case SSDKPlatformSubTypeQZone: {
            break;
        }
        case SSDKPlatformTypeCopy: {
            break;
        }
        case SSDKPlatformSubTypeWechatSession: {
            break;
        }
        case SSDKPlatformSubTypeWechatTimeline: {
            break;
        }
        case SSDKPlatformSubTypeQQFriend: {
            break;
        }
        default:
            [dictionary SSDKSetupShareParamsByText:content images:imageUrl url:[NSURL URLWithString:redirectUrl] title:title type:SSDKContentTypeAuto];
            break;
    }
    return dictionary;
}

@end
