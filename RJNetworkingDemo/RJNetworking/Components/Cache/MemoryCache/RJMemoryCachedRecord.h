//
//  RJMemoryCachedRecord.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/14.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJMemoryCachedRecord : NSObject

/// 响应对象
@property (nonatomic, strong, readonly) id responseObject;
/// 上一次更新时间
@property (nonatomic, strong, readonly) NSDate *lastUpdateTime;
/// 缓存时间
@property (nonatomic, assign) NSTimeInterval cacheTime;
/// 响应对象是否为空
@property (nonatomic, assign, readonly) BOOL isEmpty;
/// 是否过期
@property (nonatomic, assign, readonly) BOOL isOutdated;


- (instancetype)initWithResponseObject:(id)responseObject;

- (void)updateResponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
