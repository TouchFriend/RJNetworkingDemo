//
//  RJDemoServer.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoServer.h"
#import "RJRequestSerializerHelper.h"
#import "RJBaseAPIManager.h"

@implementation RJDemoServer

@synthesize baseURL = _baseURL, environment = _environment;

- (RJServerAPIEnvironment)environment {
// 发布
#ifndef DEBUG
    
    return RJServerAPIEnvironmentRelease;
    
#endif
    
    return RJServerAPIEnvironmentDevelop;
}

- (NSString *)baseURL {
    NSString *baseURL = nil;
    switch (self.environment) {
        case RJServerAPIEnvironmentRelease:
        {
            baseURL = @"https://gateway.marvel.com:443/v1";
        }
            break;
        case RJServerAPIEnvironmentDevelop:
        {
            baseURL = @"https://gateway.marvel.com:443/v1";
        }
            break;
        case RJServerAPIEnvironmentTest:
        {
            baseURL = @"https://gateway.marvel.com:443/v1";
        }
            break;
        case RJServerAPIEnvironmentPreRelease:
        {
            baseURL = @"https://gateway.marvel.com:443/v1";
        }
            break;
        default: {
            baseURL = @"https://gateway.marvel.com:443/v1";
        }
            break;
    }
    
    return baseURL;
}

- (NSMutableURLRequest *)requestWithRequestType:(RJAPIManagerRequestType)requestType URLPath:(NSString *)urlPath parameters:(id)parameters requestSerializationType:(RJAPIManagerRequestSerializerType)requestSerializationType error:(NSError * _Nullable __autoreleasing *)error {
    NSString *URLString = [self.baseURL stringByAppendingPathComponent:urlPath];
    //处理url中的中文
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 添加公有参数
    
    RJRequestSerializerHelper *serializerHelper = [RJRequestSerializerHelper sharedInstance];
    AFHTTPRequestSerializer *requestSerializer = [serializerHelper requestSerializerForType:requestSerializationType];
    NSString *requestMethod = [serializerHelper requestMethodForType:requestType];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestMethod URLString:URLString parameters:parameters error:error];
    
    // 添加公有请求头
//            [request setValue:@"" forHTTPHeaderField:@""];

    
    return request;
}

- (BOOL)handleCommonErrorWithManager:(RJBaseAPIManager *)manager response:(RJURLResponse *)response errorType:(RJAPIManagerErrorType)errorType {
    // 检查是否是取消请求
    
    // 检查是否是session失效
    
    // 检查是否是返回数据的格式错误，并给errorMessage赋值：RJAPIManagerErrorTypeResponseDataError
    
    
    // 常规错误
    switch (errorType) {
        case RJAPIManagerErrorTypeNoNetwork:
        {
            manager.errorMessage = @"无网络连接，请检查网络";
        }
            break;
        case RJAPIManagerErrorTypeTimeout:
        {
            manager.errorMessage = @"请求超时";
        }
            break;
        case RJAPIManagerErrorTypeCanceled:
        {
            manager.errorMessage = @"您已取消";
        }
            break;
            
        default:
            break;
    }
    return YES;
}

@end
