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
    RJAPIManagerErrorTypeDefault = 0,           // 没有产生过API请求，这个是manager的默认状态。
    RJAPIManagerErrorTypeNeedLogin,            //   session失效，需要重新登录
    RJAPIManagerErrorTypeSuccess,               // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    RJAPIManagerErrorTypeNoNetwork,             // 无网络
    RJAPIManagerErrorTypeCanceled,              // 取消请求
    RJAPIManagerErrorTypeTimeout,               // 请求超时
    RJAPIManagerErrorTypeNoError,               // 无错误
    RJAPIManagerErrorTypeParameterError,        // 请求参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    RJAPIManagerErrorTypeResponseDataError      // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
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

@protocol RJAPIManagerDataReformer <NSObject>

- (id _Nullable)manager:(RJBaseAPIManager *_Nonnull)manager reformData:(id _Nullable)reformData;

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
