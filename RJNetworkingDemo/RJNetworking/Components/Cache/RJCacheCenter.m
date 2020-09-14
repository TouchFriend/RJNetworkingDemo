//
//  RJCacheCenter.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJCacheCenter.h"
#import "RJDiskCacheCenter.h"
#import "RJMemoryCacheCenter.h"

@interface RJCacheCenter ()

/// 内存缓存中心
@property (nonatomic, strong) RJMemoryCacheCenter *memoryCacheCenter;
/// 沙盒缓存中心
@property (nonatomic, strong) RJDiskCacheCenter *diskCacheCenter;

@end

@implementation RJCacheCenter

+ (instancetype)sharedInstance {
    static RJCacheCenter *cacheCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[RJCacheCenter alloc] init];
    });
    return cacheCenter;
}

#pragma mark - Public Methods

- (RJURLResponse *)fetchMemoryCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters {
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:parameters];
    RJURLResponse *response = [self.memoryCacheCenter fetchCachedRecordWithKey:key];
    return response;
}

- (void)saveMemoryCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime {
    if (!response.originRequestParameters || !serverIdentifier || !urlPath) {
        return;
    }
    
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:response.originRequestParameters];
    [self.memoryCacheCenter saveCacheWithResponse:response key:key cacheTime:cacheTime];
}

- (RJURLResponse *)fetchDiskCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters {
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:parameters];
    RJURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:key];
    return response;
}

- (void)saveDiskCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime {
    if (!response.originRequestParameters || !serverIdentifier || !urlPath) {
        return;
    }
    
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:response.originRequestParameters];
    [self.diskCacheCenter saveCacheWithResponse:response key:key cacheTime:cacheTime];
}

#pragma mark - Private Methods

- (NSString *)keyWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters {
    NSString *requestInfo = [NSString stringWithFormat:@"requestType:%ld serverIdentifier:%@ urlPath:%@ parameters；%@", requestType, serverIdentifier, urlPath, parameters];
#warning MD5
    return requestInfo;
}

#pragma mark - Property Methods

- (RJMemoryCacheCenter *)memoryCacheCenter {
    if (!_memoryCacheCenter) {
        _memoryCacheCenter = [[RJMemoryCacheCenter alloc] init];
    }
    return _memoryCacheCenter;
}

- (RJDiskCacheCenter *)diskCacheCenter {
    if (!_diskCacheCenter) {
        _diskCacheCenter = [[RJDiskCacheCenter alloc] init];
    }
    return _diskCacheCenter;
}

@end
