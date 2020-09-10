//
//  RJDiskCacheCenter.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDiskCacheCenter.h"

static NSString * const RJDiskCacheCenterCacheObjectKeyPrefix = @"RJDiskCacheCenterCacheObjectKeyPrefix";
static NSString * const RJContentKey = @"content";
static NSString * const RJLastUpdateTimeKey = @"lastUpdateTime";
static NSString * const RJCacheTimeKey = @"cacheTime";


@interface RJDiskCacheCenter ()

@end

@implementation RJDiskCacheCenter

- (RJURLResponse *)fetchCachedRecordWithKey:(NSString *)key {
    NSString *actualKey = [self getActualKey:key];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:actualKey];
    if (!data) {
        return nil;
    }
    
    NSError *serializationError = nil;
    NSDictionary *fetchedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
    if (serializationError) {
        NSLog(@"JSON serialization error:%@", serializationError);
        return nil;
    }
    
    NSNumber *lastUpdateDateNumber = fetchedObject[RJLastUpdateTimeKey];
    NSNumber *cacheTimeNumber = fetchedObject[RJCacheTimeKey];
    NSDate *lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:lastUpdateDateNumber.doubleValue];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateDate];
    if (timeInterval > cacheTimeNumber.doubleValue) { // 过期
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:actualKey];
        return nil;
    }
    
    RJURLResponse *response = [[RJURLResponse alloc] initWithCachedResponseObject:fetchedObject[RJContentKey]];
    return response;
}

- (void)saveCacheWithResponse:(RJURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime {
    if (!response.responseObject) {
        return;
    }
    
    NSDictionary *saveObject = @{
        RJContentKey : response.responseObject,
        RJLastUpdateTimeKey : @([NSDate date].timeIntervalSince1970),
        RJCacheTimeKey : @(cacheTime)
    };
    
    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:saveObject options:NSJSONWritingPrettyPrinted error:&serializationError];
    if (serializationError) {
        NSLog(@"JSON serialization error:%@", serializationError);
        return;
    }
    
    NSString *actualKey = [self getActualKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:actualKey];
}

- (NSString *)getActualKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@%@", RJDiskCacheCenterCacheObjectKeyPrefix, key];
}

- (void)cleanAll
{
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSArray *keys = [[defaultsDict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", RJDiskCacheCenterCacheObjectKeyPrefix]];
    for(NSString *key in keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

@end
