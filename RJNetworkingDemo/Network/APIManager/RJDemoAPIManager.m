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

@end
