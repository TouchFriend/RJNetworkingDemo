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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.successBlock) {
            self.successBlock(self);
        }
        if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
            [self.delegate managerCallAPIDidSuccess:self];
        }
    });
    
}

- (void)failOnCallingAPI:(RJURLResponse *)response errorType:(RJAPIManagerErrorType)errorType {
    [self.requestIDList removeObject:@(response.requestID)];
    self.response = response;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.failBlock) {
            self.failBlock(self);
        }
        if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
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

#pragma mark - Property Methods

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
