//
//  RJAPIProxy.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJURLResponse.h"

typedef void(^RJAPIProxyCallbackBlock)(RJURLResponse * _Nonnull response);

NS_ASSUME_NONNULL_BEGIN

@interface RJAPIProxy : NSObject

/// 单例
+ (instancetype)sharedInstance;

/// 创建请求任务
/// @param request NSURLRequest实例
/// @param success 成功回调
/// @param fail 失败回调
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(RJAPIProxyCallbackBlock)success fail:(RJAPIProxyCallbackBlock)fail;

/// 取消请求任务
/// @param requestID 请求ID
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/// 取消多个请求任务
/// @param requestIDList 请求ID
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end

NS_ASSUME_NONNULL_END
