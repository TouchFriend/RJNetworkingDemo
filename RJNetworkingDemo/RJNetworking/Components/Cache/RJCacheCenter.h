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

- (void)saveDiskCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime;

- (RJURLResponse *)fetchDiskCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters;

@end

NS_ASSUME_NONNULL_END
