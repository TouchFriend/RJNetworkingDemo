//
//  RJDiskCacheCenter.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJDiskCacheCenter : NSObject

- (RJURLResponse *)fetchCachedRecordWithKey:(NSString *)key;

- (void)saveCacheWithResponse:(RJURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime;

- (void)cleanAll;

@end

NS_ASSUME_NONNULL_END
