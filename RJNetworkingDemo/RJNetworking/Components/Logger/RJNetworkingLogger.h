//
//  RJNetworkingLogger.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/16.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJServerProtocol.h"
#import "RJURLResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJNetworkingLogger : NSObject

+ (void)logDebugInfoWithRequst:(NSURLRequest *)request apiName:(NSString *)apiName server:(id <RJServerProtocol>)server;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject request:(NSURLRequest *)request error:(NSError *)error;

+ (void)logDebugInfoWithCachedResponse:(RJURLResponse *)response apiName:(NSString *)apiName server:(id <RJServerProtocol>)server parameters:(id)parameters;

@end

NS_ASSUME_NONNULL_END
