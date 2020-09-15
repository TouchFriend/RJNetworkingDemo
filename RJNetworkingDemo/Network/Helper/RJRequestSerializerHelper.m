//
//  RJRequestSerializerHelper.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJRequestSerializerHelper.h"

@interface RJRequestSerializerHelper ()

/// 表单请求序列化
@property (nonatomic, strong) AFHTTPRequestSerializer *httpSerializer;
/// json请求序列化
@property (nonatomic, strong) AFJSONRequestSerializer *jsonSerializer;
/// xml请求序列化
@property (nonatomic, strong) AFPropertyListRequestSerializer *propertyListSerializer;


@end

@implementation RJRequestSerializerHelper

+ (instancetype)sharedInstance {
    static RJRequestSerializerHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[RJRequestSerializerHelper alloc] init];
    });
    return helper;
}

#pragma mark - Public Methods

- (AFHTTPRequestSerializer *)requestSerializerForType:(RJAPIManagerRequestSerializerType)type {
    if (type == RJAPIManagerRequestSerializerTypeHTTP) {
        return self.httpSerializer;
    }
    
    if (type == RJAPIManagerRequestSerializerTypeJSON) {
        return self.jsonSerializer;
    }
    
    if (type == RJAPIManagerRequestSerializerTypePropertyList) {
        return self.propertyListSerializer;
    }
    
    return self.httpSerializer;
}

- (NSString *)requestMethodForType:(RJAPIManagerRequestType)type {
    NSString *method = nil;
    switch (type) {
        case RJAPIManagerRequestTypePost:
        {
            method = @"POST";
        }
            break;
        case RJAPIManagerRequestTypeGet:
        {
            method = @"GET";
        }
            break;
        case RJAPIManagerRequestTypePut:
        {
            method = @"PUT";
        }
            break;
        case RJAPIManagerRequestTypeDelete:
        {
            method = @"DELETE";
        }
            break;
        case RJAPIManagerRequestTypePatch:
        {
            method = @"PATCH";
        }
            break;
        case RJAPIManagerRequestTypeHead:
        {
            method = @"HEAD";
        }
            break;
            
        default: {
            method = @"POST";
        }
            break;
    }
    
    return method;
}

#pragma mark - Private Methods

- (void)configurateRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    requestSerializer.timeoutInterval = 20.0;       // 超时时间
    requestSerializer.HTTPShouldHandleCookies = YES;        // 是否使用cookie
    // 添加公有请求头
//    [requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
}

#pragma mark - Property Methods

- (AFHTTPRequestSerializer *)httpSerializer {
    if (!_httpSerializer) {
        _httpSerializer = [AFHTTPRequestSerializer serializer];
        [self configurateRequestSerializer:_httpSerializer];
    }
    return _httpSerializer;
}

- (AFJSONRequestSerializer *)jsonSerializer {
    if (!_jsonSerializer) {
        _jsonSerializer = [AFJSONRequestSerializer serializer];
        [self configurateRequestSerializer:_jsonSerializer];
    }
    return _jsonSerializer;
}

- (AFPropertyListRequestSerializer *)propertyListSerializer {
    if (!_propertyListSerializer) {
        _propertyListSerializer = [AFPropertyListRequestSerializer serializer];
        [self configurateRequestSerializer:_propertyListSerializer];
    }
    return _propertyListSerializer;
}

@end
