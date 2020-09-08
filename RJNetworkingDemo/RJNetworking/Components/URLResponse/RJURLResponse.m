//
//  RJURLResponse.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJURLResponse.h"

@interface RJURLResponse ()

/// 响应状态
@property (nonatomic, assign, readwrite) RJURLResponseStatus status;
/// 响应数据
@property (nonatomic, strong, readwrite) id responseObject;
/// 请求ID
@property (nonatomic, assign, readwrite) NSInteger requestID;
/// 请求
@property (nonatomic, strong, readwrite) NSURLRequest *request;
/// 错误
@property (nonatomic, strong, readwrite) NSError *error;
/// 是否缓存
@property (nonatomic, assign, getter=isCache, readwrite) BOOL cache;

@end

@implementation RJURLResponse

- (instancetype)initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error {
    self = [super self];
    if (self) {
        self.requestID = requestID.integerValue;
        self.request = request;
        self.responseObject = responseObject;
        self.error = error;
        self.cache = NO;
        self.status = [self responseStatusForError:error];
    }
    return self;
}

#pragma mark - Private Methods

- (RJURLResponseStatus)responseStatusForError:(NSError *)error {
    if (error) {
        RJURLResponseStatus status = RJURLResponseStatusErrorNoNetwork;
        switch (error.code) {
            case NSURLErrorTimedOut:
            {
                status = RJURLResponseStatusErrorTimeout;
            }
                break;
            case NSURLErrorCancelled:
            {
                status = RJURLResponseStatusErrorCanceled;
            }
                break;
            case NSURLErrorNotConnectedToInternet:
            {
                status = RJURLResponseStatusErrorNoNetwork;
            }
                break;
                
            default:
            {
                status = RJURLResponseStatusErrorNoNetwork;
            }
                break;
        }
        return status;
    } else {
        return RJURLResponseStatusSuccess;
    }
}

@end
