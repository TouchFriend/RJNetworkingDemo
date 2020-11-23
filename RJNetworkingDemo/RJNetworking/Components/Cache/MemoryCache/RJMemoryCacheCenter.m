//
//  RJMemoryCacheCenter.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJMemoryCacheCenter.h"
#import "RJMemoryCachedRecord.h"
#import "RJNetworkingConfig.h"

@interface RJMemoryCacheCenter ()

/// 内存缓存
@property (nonatomic, strong) NSCache *cache;


@end

@implementation RJMemoryCacheCenter

#pragma mark - Public Methods

- (RJURLResponse *)fetchCachedRecordWithKey:(NSString *)key {
    RJMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (!cachedRecord) {
        return nil;
    }
    
    if (cachedRecord.isOutdated || cachedRecord.isEmpty) { // 过期或者值为空
        [self.cache removeObjectForKey:key];
        return nil;
    }
    
    RJURLResponse *response = [[RJURLResponse alloc] initWithCachedResponseObject:cachedRecord.responseObject];
    return response;
    
}

- (void)saveCacheWithResponse:(RJURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime {
    RJMemoryCachedRecord *cachedRecord = [self.cache objectForKey:key];
    if (!cachedRecord) {
        cachedRecord = [[RJMemoryCachedRecord alloc] init];
    }
    cachedRecord.cacheTime = cacheTime;
    [cachedRecord updateResponseObject:response.responseObject];
    [self.cache setObject:cachedRecord forKey:key];
}

- (void)cleanAll {
    [self.cache removeAllObjects];
}


#pragma mark - Property Methods

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = [RJNetworkingConfig shareInstance].cacheResponseCountLimit;
    }
    return _cache;
}

@end
