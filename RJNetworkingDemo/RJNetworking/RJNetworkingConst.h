//
//  RJNetworkingConst.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJBaseAPIManager, RJURLResponse;

/// 服务器api环境
typedef NS_ENUM(NSUInteger, RJServerAPIEnvironment) {
    RJServerAPIEnvironmentDevelop = 0,         // 开发
    RJServerAPIEnvironmentTest,                // 测试
    RJServerAPIEnvironmentPreRelease,          // 预发布
    RJServerAPIEnvironmentRelease              // 发布
};

/// 请求类型
typedef NS_ENUM(NSUInteger, RJAPIManagerRequestType) {
    RJAPIManagerRequestTypeGet = 0,
    RJAPIManagerRequestTypePost,
    RJAPIManagerRequestTypePut,
    RJAPIManagerRequestTypeDelete,
    RJAPIManagerRequestTypePatch,
    RJAPIManagerRequestTypeHead
};

/// 请求序列化类型
typedef NS_ENUM(NSUInteger, RJAPIManagerRequestSerializerType) {
    RJAPIManagerRequestSerializerTypeJSON = 0,                //  JSON
    RJAPIManagerRequestSerializerTypeHTTP,                    //  form-data
    RJAPIManagerRequestSerializerTypePropertyList             //  XML
};

typedef NS_ENUM(NSUInteger, RJAPIManagerErrorType) {
    RJAPIManagerErrorTypeDefault = 0,
    RJAPIManagerErrorTypeNeedLogin,
    RJAPIManagerErrorTypeSuccess,
    RJAPIManagerErrorTypeNoNetwork,
    RJAPIManagerErrorTypeCanceled,
    RJAPIManagerErrorTypeTimeout,
    RJAPIManagerErrorTypeNoError,
    RJAPIManagerErrorTypeParameterError,
    RJAPIManagerErrorTypeResponseDataError
};

typedef NS_OPTIONS(NSUInteger, RJAPIManagerCachePolicy) {
    RJAPIManagerCachePolicyNoCache = 0,             // 不缓存
    RJAPIManagerCachePolicyMemory = 1 << 0,         // 内存缓存
    RJAPIManagerCachePolicyDisk = 1 << 1,           // 沙盒缓存
};

@protocol RJAPIManagerCallbackDelegate <NSObject>

- (void)managerCallAPIDidSuccess:(RJBaseAPIManager *_Nonnull)manager;
- (void)managerCallAPIDidFailed:(RJBaseAPIManager *_Nonnull)manager;

@end

@protocol RJAPIManagerParametersSource <NSObject>

- (id _Nullable)parametersForAPI:(RJBaseAPIManager *_Nonnull)manager;

@end

@protocol RJAPIManagerValidator <NSObject>

- (RJAPIManagerErrorType)manager:(RJBaseAPIManager *_Nonnull)manager isCorrectWithParameterData:(id _Nullable)parameterData;

- (RJAPIManagerErrorType)manager:(RJBaseAPIManager *_Nonnull)manager isCorrectWithResponseData:(id _Nullable)responseData;

@end

@protocol RJAPIManagerInterceptor <NSObject>

@optional

- (BOOL)manager:(RJBaseAPIManager *_Nonnull)manager shouldCallAPIWithParameters:(id _Nullable)parameters;
- (void)manager:(RJBaseAPIManager *_Nonnull)manager afterCallAPIWithParameters:(id _Nullable)parameters;
- (void)manager:(RJBaseAPIManager *_Nonnull)manager didReceiveResponse:(RJURLResponse *_Nonnull)response;

- (BOOL)manager:(RJBaseAPIManager *_Nonnull)manager beforePerformSuccessWithResponse:(RJURLResponse *_Nonnull)response;
- (void)manager:(RJBaseAPIManager *_Nonnull)manager afterPerformSuccessWithResponse:(RJURLResponse *_Nonnull)response;

- (BOOL)manager:(RJBaseAPIManager *_Nonnull)manager beforePerformFailWithResponse:(RJURLResponse *_Nonnull)response;
- (void)manager:(RJBaseAPIManager *_Nonnull)manager afterPerformFailWithResponse:(RJURLResponse *_Nonnull)response;

@end
