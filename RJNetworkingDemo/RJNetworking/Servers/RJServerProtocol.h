//
//  RJServerProtocol.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJNetworkingConst.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RJServerProtocol <NSObject>

/// 服务器环境
@property (nonatomic, assign) RJServerAPIEnvironment environment;
/// 基本URL
@property (nonatomic, copy) NSString *baseURL;


- (nullable NSMutableURLRequest *)requestWithRequestType:(RJAPIManagerRequestType)requestType URLPath:(NSString *)urlPath parameters:(nullable id)parameters  requestSerializationType:(RJAPIManagerRequestSerializerType)requestSerializationType error:(NSError * _Nullable __autoreleasing *)error;

/// 如果检查错误之后，需要继续走fail路径上报到业务层的，return YES。（例如网络错误等，需要业务层弹框）    如果检查错误之后，不需要继续走fail路径上报到业务层的，return NO。（例如用户token失效，此时挂起API，调用刷新token的API，成功之后再重新调用原来的API。那么这种情况就不需要继续走fail路径上报到业务。） 
/// @param manager RJBaseAPIManager对象
/// @param response 响应对象
/// @param errorType 错误类型
- (BOOL)handleCommonErrorWithManager:(RJBaseAPIManager *)manager response:(RJURLResponse *)response errorType:(RJAPIManagerErrorType)errorType;

@optional

/// 会话管理者
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END
