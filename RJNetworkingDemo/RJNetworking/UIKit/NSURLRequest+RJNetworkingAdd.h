//
//  NSURLRequest+RJNetworkingAdd.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJServerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (RJNetworkingAdd)

/// 原有的请求参数
@property (nonatomic, copy) id rj_originRequestParameters;
/// 实际的请求参数
@property (nonatomic, copy) id rj_actualRequestParameters;
/// 服务器
@property (nonatomic, strong) id <RJServerProtocol> rj_server;


@end

NS_ASSUME_NONNULL_END
