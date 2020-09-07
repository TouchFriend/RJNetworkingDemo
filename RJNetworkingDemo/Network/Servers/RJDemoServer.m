//
//  RJDemoServer.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoServer.h"
#import "RJRequestSerializerHelper.h"

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

@end
