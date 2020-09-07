//
//  RJRequestSerializerHelper.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJRequestSerializerHelper.h"

@interface RJRequestSerializerHelper ()

/// <#Desription#>
@property (nonatomic, strong) AFHTTPRequestSerializer *httpSerializer;
/// <#Desription#>
@property (nonatomic, strong) AFJSONRequestSerializer *jsonSerializer;
/// <#Desription#>
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

#pragma mark - Property Methods

- (AFHTTPRequestSerializer *)httpSerializer {
    if (!_httpSerializer) {
        _httpSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpSerializer;
}

- (AFJSONRequestSerializer *)jsonSerializer {
    if (!_jsonSerializer) {
        _jsonSerializer = [AFJSONRequestSerializer serializer];
    }
    return _jsonSerializer;
}

- (AFPropertyListRequestSerializer *)propertyListSerializer {
    if (!_propertyListSerializer) {
        _propertyListSerializer = [AFPropertyListRequestSerializer serializer];
    }
    return _propertyListSerializer;
}

@end
