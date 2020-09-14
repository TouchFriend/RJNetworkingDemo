//
//  RJBaseAPIManager.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJNetworkingConst.h"
#import "RJURLResponse.h"

typedef void(^RJAPIManagerCallbackBlock)(RJBaseAPIManager * _Nonnull apiManager);

NS_ASSUME_NONNULL_BEGIN

@interface RJBaseAPIManager : NSObject

/// 代理
@property (nonatomic, weak) id <RJAPIManagerCallbackDelegate> _Nullable delegate;
/// 参数代理
@property (nonatomic, weak) id <RJAPIManagerParametersSource> _Nullable parametersSource;
/// 数据验证器
@property (nonatomic, weak) id <RJAPIManagerValidator> _Nullable validator;
/// 拦截器
@property (nonatomic, weak) id <RJAPIManagerInterceptor> _Nullable interceptor;

/// url路径
- (NSString *_Nonnull)urlPath;
/// 服务器标识符（服务器类名）
- (NSString *_Nonnull)serverIdentifier;
/// 请求类型 默认POST
- (RJAPIManagerRequestType)requestType;
/// 请求序列化类型 默认HTTP
- (RJAPIManagerRequestSerializerType)requestSerializerType;
/// 请求头
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *_Nullable headers;

/// 响应
@property (nonatomic, strong) RJURLResponse *response;
/// 错误类型
@property (nonatomic, assign, readonly) RJAPIManagerErrorType errorType;
/// 错误信息
@property (nonatomic, copy, readonly) NSString *_Nullable errorMessage;

/// 缓存策略
@property (nonatomic, assign) RJAPIManagerCachePolicy cachePolicy;
/// 内存缓存时间，默认3 x 60秒
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond;
/// 沙盒缓存时间，默认3 x 60秒
@property (nonatomic, assign) NSTimeInterval diskCacheSecond;
/// 是否忽略缓存 默认NO
@property (nonatomic, assign) BOOL shouldIgnoreCache;


/// 是否有网络
@property (nonatomic, assign, readonly) BOOL isReachable;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;


/// 成功回调闭包
@property (nonatomic, copy) RJAPIManagerCallbackBlock successBlock;
/// 失败回调闭包
@property (nonatomic, copy) RJAPIManagerCallbackBlock failBlock;


/// 加载数据，参数源为parametersSource
/// @return 请求id
- (NSInteger)loadData;

/// 加载数据
/// @param parameters 参数
/// @return 请求id
- (NSInteger)loadDataWithParameters:(nullable id)parameters;

/// 取消请求
/// @param requestID 请求id
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

/// 取消所有请求
- (void)cancelAllRequests;

/// 更新错误类型
/// @param errorType 新的错误类型
- (void)updateErrorType:(RJAPIManagerErrorType)errorType;

/// 更新错误信息
/// @param errorMessage 新的错误信息
- (void)updateErrorMessage:(NSString *)errorMessage;

@end

NS_ASSUME_NONNULL_END


@interface RJBaseAPIManager (InnerInterceptor)

/// 调用API之前，会调用此方法。
/// @param parameters 请求参数
/// @return 返回YES，调用API。返回NO，不调用API。
- (BOOL)shouldCallAPIWithParameters:(id _Nullable)parameters;

/// 调用API之后，会调用此方法
/// @param parameters 请求参数
- (void)afterCallAPIWithParameters:(id _Nullable)parameters;

- (BOOL)beforePerformSuccessWithResponse:(RJURLResponse *_Nonnull)response;

- (void)afterPerformSuccessWithResponse:(RJURLResponse *_Nonnull)response;

- (BOOL)beforePerformFailWithResponse:(RJURLResponse *_Nonnull)response;

- (void)afterPerformFailWithResponse:(RJURLResponse *_Nonnull)response;

@end
