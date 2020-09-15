//
//  RJAPIProxy.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAPIProxy.h"
#import <AFNetworking/AFNetworking.h>

@interface RJAPIProxy ()

/// sessionManager
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
/// 分发表
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;


@end

@implementation RJAPIProxy

+ (instancetype)sharedInstance {
    static RJAPIProxy *proxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[RJAPIProxy alloc] init];
    });
    return proxy;
}

#pragma mark - Public methods

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(RJAPIProxyCallbackBlock)success fail:(RJAPIProxyCallbackBlock)fail {
    __block NSURLSessionDataTask *task = nil;
    __weak typeof(self) weakSelf = self;
    task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"responseObject:%@ \nerror:%@", responseObject, error);
        NSNumber *requestID = [NSNumber numberWithInteger:task.taskIdentifier];
        [weakSelf.dispatchTable removeObjectForKey:requestID];
        
        RJURLResponse *urlResponse = [[RJURLResponse alloc] initWithRequestID:requestID request:request responseObject:responseObject error:error];
        if (!error) {
            if (success) {
                success(urlResponse);
            }
        } else {
            if (fail) {
                fail(urlResponse);
            }
        }
        
    }];
    NSNumber *requestID = [NSNumber numberWithInteger:task.taskIdentifier];
    self.dispatchTable[requestID] = task;
    [task resume];
    return requestID;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *task = self.dispatchTable[requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestID in requestIDList) {
        [self cancelRequestWithRequestID:requestID];
    }
}

#pragma mark - Property Methods

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        NSArray *responseSerializers = @[[AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer], [AFPropertyListResponseSerializer serializer], [AFImageResponseSerializer serializer]];
        _sessionManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];
        
    }
    return _sessionManager;;
}

- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

@end
