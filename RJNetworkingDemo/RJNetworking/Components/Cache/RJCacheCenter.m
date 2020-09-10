//
//  RJCacheCenter.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJCacheCenter.h"
#import "RJDiskCacheCenter.h"

@interface RJCacheCenter ()

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

- (void)saveDiskCacheWithResponse:(RJURLResponse *)response requestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath cacheTime:(NSTimeInterval)cacheTime {
    if (!response.originRequestParameters || !serverIdentifier || !urlPath) {
        return;
    }
    
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:response.originRequestParameters];
    [self.diskCacheCenter saveCacheWithResponse:response key:key cacheTime:cacheTime];
}

- (RJURLResponse *)fetchDiskCacheWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters {
    NSString *key = [self keyWithRequestType:requestType serverIdentifier:serverIdentifier urlPath:urlPath parameters:parameters];
    RJURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:key];
    return response;
}

#pragma mark - Private Methods

- (NSString *)keyWithRequestType:(RJAPIManagerRequestType)requestType serverIdentifier:(NSString *)serverIdentifier urlPath:(NSString *)urlPath parameters:(id)parameters {
    NSString *requestInfo = [NSString stringWithFormat:@"requestType:%ld serverIdentifier:%@ urlPath:%@ parameters；%@", requestType, serverIdentifier, urlPath, parameters];
#warning MD5
    return requestInfo;
}

#pragma mark - Property Methods

- (RJDiskCacheCenter *)diskCacheCenter {
    if (!_diskCacheCenter) {
        _diskCacheCenter = [[RJDiskCacheCenter alloc] init];
    }
    return _diskCacheCenter;
}

@end
