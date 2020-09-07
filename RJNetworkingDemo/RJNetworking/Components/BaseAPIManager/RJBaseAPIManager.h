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
@property (nonatomic, weak, nullable) id <RJAPIManagerCallbackDelegate> delegate;
/// url路径
@property (nonatomic, copy) NSString *urlPath;
/// 服务器标识符（服务器类名）
@property (nonatomic, copy) NSString *serverIdentifier;
/// 请求类型 默认POST
@property (nonatomic, assign) RJAPIManagerRequestType requestType;
/// 请求序列化类型 默认HTTP
@property (nonatomic, assign) RJAPIManagerRequestSerializerType requestSerializerType;
/// 请求头
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *headers;

/// 响应
@property (nonatomic, strong) RJURLResponse *response;
/// 成功回调闭包
@property (nonatomic, copy) RJAPIManagerCallbackBlock successBlock;
/// 失败回调闭包
@property (nonatomic, copy) RJAPIManagerCallbackBlock failBlock;



- (NSInteger)loadDataWithParameters:(nullable id)parameters;

- (void)cancelRequestWithRequestID:(NSInteger)requestID;

- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
