//
//  RJNetworkingConfig.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/11/23.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJNetworkingConfig : NSObject

/// 单例
+ (instancetype)shareInstance;

/// debug信息开关，默认开启
@property (nonatomic, assign) BOOL debugMode;
/// 缓存在内存中的响应数据数量限制，默认10
@property (nonatomic, assign) NSUInteger cacheResponseCountLimit;

@end

NS_ASSUME_NONNULL_END
