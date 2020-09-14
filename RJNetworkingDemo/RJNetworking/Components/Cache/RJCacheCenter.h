//
//  RJCacheCenter.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJURLResponse.h"
#import "RJNetworkingConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJCacheCenter : NSObject

/// 单例
+ (instancetype)sharedInstance;

/// 拉取缓存在内存中的数据
/// @param requestType 请求类型
/// @param serverIdentifier 服务器标识符
/// @param urlPath 请求路径
/// @param parameters 参数
/// @return 响应数据
- (RJURLResponse *)fetchMemoryCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters;

/// 保存数据到内存缓存中
/// @param response 响应数据
/// @param requestType 请求类型
/// @param serverIdentifier 服务器标识符
/// @param urlPath 请求路径
/// @param cacheTime 参数
- (void)saveMemoryCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime;

/// 拉取缓存在沙盒中的数据
/// @param requestType 请求类型
/// @param serverIdentifier 服务器标识符
/// @param urlPath 请求路径
/// @param parameters 参数
/// @return 响应数据
- (RJURLResponse *)fetchDiskCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters;

/// 保存数据到沙盒缓存中
/// @param response 响应数据
/// @param requestType 请求类型
/// @param serverIdentifier 服务器标识符
/// @param urlPath 请求路径
/// @param cacheTime 参数
- (void)saveDiskCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime;

@end

NS_ASSUME_NONNULL_END
