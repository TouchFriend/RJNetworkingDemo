//
//  RJBaseAPIManager.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJBaseAPIManager.h"
#import "RJServerFactory.h"
#import "RJAPIProxy.h"

@interface RJBaseAPIManager ()

/// 请求ID列表
@property (nonatomic, strong) NSMutableArray *requestIDList;

@end

@implementation RJBaseAPIManager

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.errorType = RJAPIManagerErrorTypeDefault;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self cancelAllRequests];
    self.requestIDList = nil;
}

#pragma mark - Public Methods

- (NSInteger)loadData {
    id parameters = [self.parametersSource parametersForAPI:self];
    return [self loadDataWithParameters:parameters];
}

- (NSInteger)loadDataWithParameters:(id)parameters {
    if (parameters && ![parameters isKindOfClass:[NSDictionary class]] && ![parameters isKindOfClass:[NSArray class]]) {
        NSAssert(NO, @"请求参数的类型必须是NSDictionary或者NSArray");
        return 0;
    }
    
    if (![self shouldCallAPIWithParameters:parameters]) {
        return 0;
    }
    
    // 验证参数是否符合预期
    RJAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithParameterData:parameters];
    if (errorType != RJAPIManagerErrorTypeNoError) {
        [self failOnCallingAPI:nil errorType:errorType];
        return 0;
    }
    
    id <RJServerProtocol> server = [[RJServerFactory sharedInstance] serverWithIdentifier:self.serverIdentifier];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [server requestWithRequestType:self.requestType URLPath:self.urlPath parameters:parameters requestSerializationType:self.requestSerializerType error:&serializerError];
    
    if (serializerError) {
        NSLog(@"serializerError:%@", serializerError);
        return 0;
    }
    
    // 添加私有请求头
    for (NSString *headerField in self.headers.keyEnumerator) {
        [request setValue:self.headers[headerField] forHTTPHeaderField:headerField];
    }
    
    __weak typeof(self) weakSelf = self;
    NSNumber *requestID = [[RJAPIProxy sharedInstance] callApiWithRequest:request success:^(RJURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf successOnCallingAPI:response];
    } fail:^(RJURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        RJAPIManagerErrorType errorType = [strongSelf responseStatusParseToAPIManagerErrorType:response.status];
        [strongSelf failOnCallingAPI:response errorType:errorType];
    }];
    NSLog(@"requestID:%@", requestID);
    [self.requestIDList addObject:requestID];
    [self afterCallAPIWithParameters:parameters];
    return requestID.integerValue;
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID {
    [self.requestIDList removeObject:@(requestID)];
    [[RJAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)cancelAllRequests {
    [[RJAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIDList];
    [self.requestIDList removeAllObjects];
}

#pragma mark - Private Methods

- (void)successOnCallingAPI:(RJURLResponse *)response {
    [self.requestIDList removeObject:@(response.requestID)];
    self.response = response;
    
    // 验证响应数据是否符合预期
    RJAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithResponseData:response.responseObject];
    if (errorType != RJAPIManagerErrorTypeNoError) {
        [self failOnCallingAPI:response errorType:errorType];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformSuccessWithResponse:response]) {
            if (self.successBlock) {
                self.successBlock(self);
            }
            if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        
        [self afterPerformSuccessWithResponse:response];
    });
}

- (void)failOnCallingAPI:(RJURLResponse *)response errorType:(RJAPIManagerErrorType)errorType {
    [self.requestIDList removeObject:@(response.requestID)];
    self.response = response;
    self.errorType = errorType;
    
    id <RJServerProtocol> server = [[RJServerFactory sharedInstance] serverWithIdentifier:self.serverIdentifier];
    BOOL shouldContinue = [server handleCommonErrorWithManager:self response:response errorType:errorType];
    if (!shouldContinue) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformFailWithResponse:response]) {
            if (self.failBlock) {
                self.failBlock(self);
            }
            if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
                [self.delegate managerCallAPIDidFailed:self];
            }
        }
        
        [self afterPerformFailWithResponse:response];
    });
}

- (RJAPIManagerErrorType)responseStatusParseToAPIManagerErrorType:(RJURLResponseStatus)responseStatus {
    RJAPIManagerErrorType errorType = RJAPIManagerErrorTypeNoNetwork;
    switch (responseStatus) {
        case RJURLResponseStatusErrorTimeout:
        {
            errorType = RJAPIManagerErrorTypeTimeout;
        }
            break;
        case RJURLResponseStatusErrorCanceled:
        {
            errorType = RJAPIManagerErrorTypeCanceled;
        }
            break;
        case RJURLResponseStatusErrorNoNetwork:
        {
            errorType = RJAPIManagerErrorTypeNoNetwork;
        }
            break;
        default:
        {
            errorType = RJAPIManagerErrorTypeNoNetwork;
        }
            break;
    }
    return errorType;
}

#pragma mark - Intercetpor Methods

/*
   拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
   当两种情况共存的时候，子类重载的方法一定要调用一下super
   然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
   
   notes:
       正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
       但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
       所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
       这就是decorate pattern
*/

- (BOOL)shouldCallAPIWithParameters:(id)parameters {
    BOOL result = YES;
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParameters:)]) {
        result = [self.interceptor manager:self shouldCallAPIWithParameters:parameters];
    }
    return result;
}

- (void)afterCallAPIWithParameters:(id)parameters {
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:afterCallAPIWithParameters:)]) {
        [self.interceptor manager:self afterCallAPIWithParameters:parameters];
    }
}

- (BOOL)beforePerformSuccessWithResponse:(RJURLResponse *)response {
    BOOL result = YES;
    self.errorType = RJAPIManagerErrorTypeSuccess;
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(RJURLResponse *)response {
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(RJURLResponse *)response {
    BOOL result = YES;
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(RJURLResponse *)response {
    if (self.interceptor != self && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

#pragma mark - Property Methods

- (NSString *)urlPath {
    return @"";
}

- (NSString *)serverIdentifier {
    return @"";
}

- (RJAPIManagerRequestType)requestType {
    return RJAPIManagerRequestTypePost;
}

- (RJAPIManagerRequestSerializerType)requestSerializerType {
    return RJAPIManagerRequestSerializerTypeHTTP;
}

- (NSMutableArray *)requestIDList {
    if (!_requestIDList) {
        _requestIDList = [NSMutableArray array];
    }
    return _requestIDList;
}

@end
