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
#import "NSURLRequest+RJNetworkingAdd.h"
#import <AFNetworking/AFSecurityPolicy.h>

@interface RJDemoServer ()

@end

@implementation RJDemoServer

@synthesize baseURL = _baseURL, environment = _environment, sessionManager = _sessionManager;

#pragma mark - RJServerProtocol Methods

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
    request.rj_originRequestParameters = parameters;
    request.rj_actualRequestParameters = parameters;
    
    return request;
}

- (BOOL)handleCommonErrorWithManager:(RJBaseAPIManager *)manager response:(RJURLResponse *)response errorType:(RJAPIManagerErrorType)errorType {
    // 检查是否是取消请求
    
    // 检查是否是session失效
    
    // 检查是否是返回数据的格式错误，并给errorMessage赋值：RJAPIManagerErrorTypeResponseDataError
    
    NSString *errorMessage = nil;
    // 常规错误
    switch (errorType) {
        case RJAPIManagerErrorTypeNoNetwork:
        {
            errorMessage = @"无网络连接，请检查网络";
        }
            break;
        case RJAPIManagerErrorTypeTimeout:
        {
            errorMessage = @"请求超时";
        }
            break;
        case RJAPIManagerErrorTypeCanceled:
        {
            errorMessage = @"您已取消";
        }
            break;
            
        default:
            break;
    }
    [manager updateErrorMessage:errorMessage];
    return YES;
}

#pragma mark - Private Methods

//  https证书验证
- (AFSecurityPolicy *)customSecurityPolicy
{
    //  AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书(也就是自建的证书)，默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    // validatesDomainName 是否需要验证域名，默认为YES;
    // 假如证书的域名与你请求的域名不一致，需要把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 设置为NO，主要用于这种情况：客户端请求的事子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com,那么mail.google.com是无法验证通过的；当然有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如设置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    return securityPolicy;
}

#pragma mark - Property Methods

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

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        NSArray *responseSerializers = @[[AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer], [AFPropertyListResponseSerializer serializer], [AFImageResponseSerializer serializer]];
        _sessionManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];
        // https认证模式
//        _sessionManager.securityPolicy = [self customSecurityPolicy];
    }
    return _sessionManager;
}

@end
