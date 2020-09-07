//
//  RJNetworkingConst.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJBaseAPIManager;

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

@protocol RJAPIManagerCallbackDelegate <NSObject>

- (void)managerCallAPIDidSuccess:(RJBaseAPIManager *_Nonnull)manager;
- (void)managerCallAPIDidFailed:(RJBaseAPIManager *_Nonnull)manager;

@end

@protocol RJAPIManagerParametersSource <NSObject>

- (id _Nullable)parametersForAPI:(RJBaseAPIManager * _Nonnull)manager;

@end
