//
//  RJRequestSerializerHelper.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJNetworkingConst.h"
#import <AFNetworking/AFURLRequestSerialization.h>


NS_ASSUME_NONNULL_BEGIN

@interface RJRequestSerializerHelper : NSObject

/// 单例
+ (instancetype)sharedInstance;

- (AFHTTPRequestSerializer *)requestSerializerForType:(RJAPIManagerRequestSerializerType)type;

- (NSString *)requestMethodForType:(RJAPIManagerRequestType)type;

@end

NS_ASSUME_NONNULL_END
