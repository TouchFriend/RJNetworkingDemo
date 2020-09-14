//
//  RJURLResponse.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RJURLResponseStatus) {
    RJURLResponseStatusSuccess = 0,         // 成功
    RJURLResponseStatusErrorTimeout,        // 请求超时
    RJURLResponseStatusErrorCanceled,         // 取消请求
    RJURLResponseStatusErrorNoNetwork       // 无网络 (默认处理超时外的错误都是无网络错误)
};

NS_ASSUME_NONNULL_BEGIN

@interface RJURLResponse : NSObject

/// 响应状态
@property (nonatomic, assign, readonly) RJURLResponseStatus status;
/// 响应数据
@property (nonatomic, strong, readonly) id responseObject;
/// 请求ID
@property (nonatomic, assign, readonly) NSInteger requestID;
/// 请求
@property (nonatomic, strong, readonly) NSURLRequest *request;
/// 错误
@property (nonatomic, strong, readonly) NSError *error;

/// 原有的请求参数
@property (nonatomic, copy) id originRequestParameters;
/// 实际的请求参数
@property (nonatomic, copy) id actualRequestParameters;

/// 是否缓存过
@property (nonatomic, assign, getter=isCache, readonly) BOOL cache;

- (instancetype)initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *)request responseObject:(id _Nullable)responseObject error:(NSError *_Nullable)error;

- (instancetype)initWithCachedResponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
