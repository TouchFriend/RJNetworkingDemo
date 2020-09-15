//
//  RJDemoAPIManager.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoAPIManager.h"
#import "RJDemoServer.h"
#import "RJDemoInterceptor.h"

@interface RJDemoAPIManager () <RJAPIManagerParametersSource, RJAPIManagerValidator>

/// 参数
@property (nonatomic, strong) id parameters;
/// <#Desription#>
@property (nonatomic, strong) RJDemoInterceptor *demoInterceptor;


@end

@implementation RJDemoAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.demoInterceptor = [[RJDemoInterceptor alloc] init];
        self.parametersSource = self;
        self.validator = self;
        self.interceptor = self.demoInterceptor;
    }
    return self;
}

- (NSInteger)loadDataWithUserKey:(NSString *)userKey {
    NSParameterAssert(userKey);
    // https://gateway.marvel.com:443/v1/public/characters?apikey=d97bab99fa506c7cdf209261ffd06652&hash=97137e9605d1e32acbc2941c4f3eff63&ts=E2B7189A-5DEF-42B4-A5C2-7B04E7509627
    NSDictionary *parameters = @{
        @"apikey" : @"d97bab99fa506c7cdf209261ffd06652",
        @"hash" : @"97137e9605d1e32acbc2941c4f3eff63",
        @"ts" : @"E2B7189A-5DEF-42B4-A5C2-7B04E7509627"
    };
    self.parameters = parameters;
    return [self loadData];
}

#pragma mark - RJAPIManagerParametersSource Methods

- (id)parametersForAPI:(RJBaseAPIManager *)manager {
    return self.parameters;
}

#pragma mark - RJAPIManagerValidator Methods

- (RJAPIManagerErrorType)manager:(RJBaseAPIManager *)manager isCorrectWithParameterData:(id)parameterData {
    return RJAPIManagerErrorTypeNoError;
}

- (RJAPIManagerErrorType)manager:(RJBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData {
    return RJAPIManagerErrorTypeNoError;
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

- (NSDictionary *)reformParameters:(NSDictionary *)parameters {
//    NSMutableDictionary *parametersM = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    [parametersM setObject:@"addParameter" forKey:@"add"];
//    return [parametersM copy];
    return parameters;
}

@end
