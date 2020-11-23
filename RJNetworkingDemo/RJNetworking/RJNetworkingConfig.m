//
//  RJNetworkingConfig.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/11/23.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJNetworkingConfig.h"

@implementation RJNetworkingConfig

+ (instancetype)shareInstance {
    static RJNetworkingConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
        [config setupInit];
    });
    return config;
}

#pragma mark - Setup Init

- (void)setupInit {
    self.debugMode = YES;
    self.cacheResponseCountLimit = 10;
}

@end
