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

#pragma mark - private method
+ (void)sendAPIRequest:(SGAPIRequest *)request {
    if(!request) {
        return;
    }
    if(request.serverMethod.length == 0 || request.serverUrl.length == 0) {

        [SGAPIHelper notifyCompleteWithResponse:[SGAPIResponds apiRespondsWithErrorCode:SG_ERROR_CODE_UNKNOWN message:@""] callback:request.callback];
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@/%@", request.serverUrl, request.serverMethod];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setValue:@"40" forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"132" forHTTPHeaderField:@"Name"];
    [urlRequest setValue:@"a1234567812345678123456781234568" forHTTPHeaderField:@"Md5"];
    [urlRequest setValue:@"40" forHTTPHeaderField:@"TotalSize"];
    [urlRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[@"1111111111111111111111111111111111111111" dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
    }];

}

+ (void)notifyCompleteWithResponse:(SGAPIResponds *)responds callback:(SGAPICallback)callback {
    if(!responds || !callback) {
        return;
    }
    callback(responds.success, responds.data, responds.error);
}

@end
