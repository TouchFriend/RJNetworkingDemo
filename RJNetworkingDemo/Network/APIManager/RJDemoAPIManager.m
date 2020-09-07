//
//  RJDemoAPIManager.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoAPIManager.h"
#import "RJDemoServer.h"

@interface RJDemoAPIManager () <RJAPIManagerParametersSource>

/// 参数
@property (nonatomic, strong) id parameters;


@end

@implementation RJDemoAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.parametersSource = self;
    }
    return self;
}

- (NSInteger)loadDataWithUserKey:(NSString *)userKey {
    NSParameterAssert(userKey);
    NSDictionary *parameters = @{
        @"userKey" : userKey
    };
    self.parameters = parameters;
    return [self loadData];
}

#pragma mark - RJAPIManagerParametersSource Methods

- (id)parametersForAPI:(RJBaseAPIManager *)manager {
    return self.parameters;
}

#pragma mark - Override Methods

- (NSString *)urlPath {
    return @"public/characters";
}

- (NSString *)serverIdentifier {
    return NSStringFromClass([RJDemoServer class]);
}

- (RJAPIManagerRequestType)requestType {
    return RJAPIManagerRequestTypeGet;
}

- (RJAPIManagerRequestSerializerType)requestSerializerType {
    return RJAPIManagerRequestSerializerTypeHTTP;
}

@end
