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
#import "RJCacheCenter.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "NSURLRequest+RJNetworkingAdd.h"

@interface RJBaseAPIManager ()

/// 拉取的原生数据
@property (nonatomic, strong) id fetchedRawData;
/// 请求ID列表
@property (nonatomic, strong) NSMutableArray *requestIDList;
/// 错误类型
@property (nonatomic, assign, readwrite) RJAPIManagerErrorType errorType;
/// 错误信息
@property (nonatomic, copy, readwrite) NSString *errorMessage;
/// 是否正在加载
@property (nonatomic, assign, readwrite) BOOL isLoading;

@end

@implementation RJBaseAPIManager

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fetchedRawData = nil;
        self.errorType = RJAPIManagerErrorTypeDefault;
        self.cachePolicy = RJAPIManagerCachePolicyNoCache;
        self.memoryCacheSecond = 180;
        self.diskCacheSecond = 180;
        self.shouldIgnoreCache = NO;
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
    
    id reformedParameters = [self reformParameters:parameters];
    if (!reformedParameters) {
        reformedParameters = @{};
    }
    
    if (![self shouldCallAPIWithParameters:reformedParameters]) {
        return 0;
    }
    
    // 验证参数是否符合预期
    RJAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithParameterData:reformedParameters];
    if (errorType != RJAPIManagerErrorTypeNoError) {
        [self failOnCallingAPI:nil errorType:errorType];
        return 0;
    }
    
    RJURLResponse *response = nil;
    // 检查是否有内存缓存
    if ((self.cachePolicy == RJAPIManagerCachePolicyMemory) && !self.shouldIgnoreCache) {
        response = [[RJCacheCenter sharedInstance] fetchMemoryCacheWithRequestType:self.requestType serverIdentifier:self.serverIdentifier urlPath:self.urlPath parameters:reformedParameters];
    }
    
    // 再检查是否有沙盒缓存
    if ((self.cachePolicy == RJAPIManagerCachePolicyDisk) && !self.shouldIgnoreCache) {
        response = [[RJCacheCenter sharedInstance] fetchDiskCacheWithRequestType:self.requestType serverIdentifier:self.serverIdentifier urlPath:self.urlPath parameters:reformedParameters];
    }
    
    if (response) {
        [self successOnCallingAPI:response];
        return 0;
    }
    
    // 无网络
    if (!self.isReachable) {
        [self failOnCallingAPI:nil errorType:RJAPIManagerErrorTypeNoNetwork];
        return 0;
    }
    
    // 实际的网络请求
    self.isLoading = YES;
    id <RJServerProtocol> server = [[RJServerFactory sharedInstance] serverWithIdentifier:self.serverIdentifier];
    NSError *serializerError = nil;
    NSMutableURLRequest *request = [server requestWithRequestType:self.requestType URLPath:self.urlPath parameters:reformedParameters requestSerializationType:self.requestSerializerType error:&serializerError];
    
    if (serializerError) {
        NSLog(@"serializerError:%@", serializerError);
        return 0;
    }
    
    request.rj_server = server;
    // 添加私有请求头
    for (NSString *headerField in self.allHTTPHeaderFields.keyEnumerator) {
        [request setValue:self.allHTTPHeaderFields[headerField] forHTTPHeaderField:headerField];
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
    [self afterCallAPIWithParameters:reformedParameters];
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

- (id)reformParameters:(id)parameters {
    return parameters;
}

- (void)updateErrorType:(RJAPIManagerErrorType)errorType {
    self.errorType = errorType;
}

- (void)updateErrorMessage:(NSString *)errorMessage {
    self.errorMessage = errorMessage;
}

- (id)fetchDataWithReformer:(id <RJAPIManagerDataReformer>)reformer {
    id result = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        result = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        result = [self.fetchedRawData mutableCopy];
    }
    return result;
}

- (void)cleanData {
    self.fetchedRawData = nil;
    self.errorType = RJAPIManagerErrorTypeDefault;
}

#pragma mark - Private Methods

- (void)successOnCallingAPI:(RJURLResponse *)response {
    self.isLoading = NO;
    [self.requestIDList removeObject:@(response.requestID)];
    self.response = response;
    self.fetchedRawData = [response.responseObject copy];
    
    // 验证响应数据是否符合预期
    RJAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithResponseData:response.responseObject];
    if (errorType != RJAPIManagerErrorTypeNoError) {
        [self failOnCallingAPI:response errorType:errorType];
        return;
    }
    
    if (self.cachePolicy != RJAPIManagerCachePolicyNoCache && !response.isCache) {
        if (self.cachePolicy & RJAPIManagerCachePolicyMemory) {
            [[RJCacheCenter sharedInstance] saveMemoryCacheWithResponse:response requestType:self.requestType serverIdentifier:self.serverIdentifier urlPath:self.urlPath cacheTime:self.memoryCacheSecond];
        }
        
        if (self.cachePolicy & RJAPIManagerCachePolicyDisk) {
            [[RJCacheCenter sharedInstance] saveDiskCacheWithResponse:response requestType:self.requestType serverIdentifier:self.serverIdentifier urlPath:self.urlPath cacheTime:self.diskCacheSecond];
        }
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
    self.isLoading = NO;
    [self.requestIDList removeObject:@(response.requestID)];
    self.response = response;
    self.fetchedRawData = [response.responseObject copy];
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

- (BOOL)isReachable {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    BOOL reachable = manager.isReachable;
    if (!reachable) {
        self.errorType = RJAPIManagerErrorTypeNoNetwork;
    }
    return reachable;
}

- (BOOL)isLoading {
    if (self.requestIDList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

@end
