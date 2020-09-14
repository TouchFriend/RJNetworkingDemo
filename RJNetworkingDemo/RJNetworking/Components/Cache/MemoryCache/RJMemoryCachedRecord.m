//
//  RJMemoryCachedRecord.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/14.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJMemoryCachedRecord.h"

@interface RJMemoryCachedRecord ()

/// 响应对象
@property (nonatomic, strong, readwrite) id responseObject;
/// 上一次更新时间
@property (nonatomic, strong, readwrite) NSDate *lastUpdateTime;

@end

@implementation RJMemoryCachedRecord

- (instancetype)initWithResponseObject:(id)responseObject {
    self = [super init];
    if (self) {
        self.responseObject = responseObject;
    }
    return self;
}

- (void)updateResponseObject:(id)responseObject {
    self.responseObject = responseObject;
}

#pragma mark - Property Methods

- (void)setResponseObject:(id _Nonnull)responseObject {
    _responseObject = responseObject;
    self.lastUpdateTime = [NSDate date];
}

- (BOOL)isEmpty {
    return !self.responseObject;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheTime;
}

@end
