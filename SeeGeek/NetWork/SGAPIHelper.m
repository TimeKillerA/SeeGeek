//
//  SGAPIHelper.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGAPIHelper.h"
#import "SGAPIConfigration.h"
#import <AFNetworking.h>
#import "NSError+Constructor.h"

#pragma mark - SGAPIRequest
/**
 *  API请求类
 */
typedef NS_ENUM(NSInteger, SGAPIRequestHttpMethod) {
    SGAPIRequestHttpMethodPost,
    SGAPIRequestHttpMethodGet,
};

@interface SGAPIRequest : NSObject

@property (nonatomic, strong)NSDictionary *paramsDictionary;
@property (nonatomic, assign)SGAPIRequestHttpMethod httpMethod;
@property (nonatomic, copy)NSString *serverUrl;
@property (nonatomic, copy)NSString *serverMethod;
@property (nonatomic, copy)SGAPICallback callback;

+ (instancetype)apiRequestWithParams:(NSDictionary *)params
                          HttpMethod:(SGAPIRequestHttpMethod)httpMethod
                        serverMethod:(NSString *)serverMethod
                            callback:(SGAPICallback)callback;

+ (instancetype)apiRequestWithParams:(NSDictionary *)params
                          HttpMethod:(SGAPIRequestHttpMethod)httpMethod
                           serverUrl:(NSString *)serverUrl
                        serverMethod:(NSString *)serverMethod
                            callback:(SGAPICallback)callback;

@end

@implementation SGAPIRequest

+ (instancetype)apiRequestWithParams:(NSDictionary *)params
                          HttpMethod:(SGAPIRequestHttpMethod)httpMethod
                        serverMethod:(NSString *)serverMethod
                            callback:(SGAPICallback)callback {
    return [SGAPIRequest apiRequestWithParams:params
                                   HttpMethod:httpMethod
                                    serverUrl:[SGAPIConfigration baseURL]
                                 serverMethod:serverMethod
                                     callback:callback];
}

+ (instancetype)apiRequestWithParams:(NSDictionary *)params
                          HttpMethod:(SGAPIRequestHttpMethod)httpMethod
                           serverUrl:(NSString *)serverUrl
                        serverMethod:(NSString *)serverMethod
                            callback:(SGAPICallback)callback {
    SGAPIRequest *request = [[SGAPIRequest alloc] init];
    request.paramsDictionary = params;
    request.httpMethod = httpMethod;
    request.serverUrl = serverUrl;
    request.serverMethod = serverMethod;
    request.callback = callback;
    return request;
}

@end

#pragma mark - SGAPIResponds

/**
 *  API请求响应类
 */
@interface SGAPIResponds : NSObject

@property (nonatomic, strong) NSError   *error;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) BOOL      success;
@property (nonatomic, strong) id        data;

+ (instancetype)apiRespondsWithErrorCode:(NSInteger)code
                                 message:(NSString *)message;

@end

@implementation SGAPIResponds

+ (instancetype)apiRespondsWithErrorCode:(NSInteger)code
                                 message:(NSString *)message {
    SGAPIResponds *responds = [[SGAPIResponds alloc] init];
    responds.code = code;
    responds.error = [NSError errorWithCode:code message:message];
    responds.success = NO;
    responds.data = nil;
    return responds;
}

@end

#pragma mark - SGAPIHelper

@implementation SGAPIHelper

+ (void)sendRequestForLaunchAdDataWithCallback:(SGAPICallback)callback {
    [SGAPIHelper sendAPIRequest:[SGAPIRequest apiRequestWithParams:nil
                                                        HttpMethod:SGAPIRequestHttpMethodPost
                                                      serverMethod:SG_API_METHOD_UPLOAD_VIDEO
                                                          callback:callback]];
}

#pragma mark - stream list
/**
 *  获取关注列表
 *
 *  @param start    起始位置
 *  @param count    请求数量
 *  @param callback
 */
+ (void)sendRequestForFocusStreamListWithStart:(NSInteger)start
                                         count:(NSInteger)count
                                      callback:(SGAPICallback)callback {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    SGAPIRequest *request = [SGAPIRequest apiRequestWithParams:params HttpMethod:SGAPIRequestHttpMethodGet serverMethod:SG_API_METHOD_FOCUS_LIST callback:callback];
    [SGAPIHelper sendAPIRequest:request];
}

#pragma mark - private method
+ (AFHTTPSessionManager *)httpSessionManager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *httpSessionManager = nil;
    dispatch_once(&onceToken, ^{
        httpSessionManager = [AFHTTPSessionManager manager];
        httpSessionManager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [httpSessionManager.requestSerializer setValue:@"application/json;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    return httpSessionManager;
}

+ (void)sendAPIRequest:(SGAPIRequest *)request {
    if(!request) {
        return;
    }
    if(request.serverMethod.length == 0 || request.serverUrl.length == 0) {

        [SGAPIHelper notifyCompleteWithResponse:[SGAPIResponds apiRespondsWithErrorCode:SG_ERROR_CODE_UNKNOWN message:@""] callback:request.callback];
        return;
    }
    NSString *apiString = [NSString stringWithFormat:@"%@/%@", request.serverUrl, request.serverMethod];
    void (^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    };
    void (^failBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    };
    switch (request.httpMethod) {
        case SGAPIRequestHttpMethodPost: {
            [[SGAPIHelper httpSessionManager] GET:apiString parameters:request.paramsDictionary progress:nil success:successBlock failure:failBlock];
            break;
        }
        case SGAPIRequestHttpMethodGet: {
            [[SGAPIHelper httpSessionManager] POST:apiString parameters:request.paramsDictionary progress:nil success:successBlock failure:failBlock];
            break;
        }
    }
}

+ (void)notifyCompleteWithResponse:(SGAPIResponds *)responds callback:(SGAPICallback)callback {
    if(!responds || !callback) {
        return;
    }
    callback(responds.success, responds.data, responds.error);
}

@end
