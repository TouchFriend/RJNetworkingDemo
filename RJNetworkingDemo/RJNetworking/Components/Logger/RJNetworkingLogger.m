//
//  RJNetworkingLogger.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/16.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJNetworkingLogger.h"
#import "NSURLRequest+RJNetworkingAdd.h"

@implementation RJNetworkingLogger

+ (void)logDebugInfoWithRequst:(NSURLRequest *)request apiName:(NSString *)apiName server:(id <RJServerProtocol>)server {
    NSMutableString *logString = [NSMutableString string];
#ifdef DEBUG
    
    NSString *environmentString = [self environmentDecription:server.environment];
    NSString *requestDescription = [self requestDescription:request];
    
    [logString appendString:@"\n\n************************************* Request Start *************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Method:\t\t\t%@\n", request.HTTPMethod];
    [logString appendFormat:@"Server:\t\t\t%@\n", NSStringFromClass([server class])];
    [logString appendFormat:@"Environment:\t%@\n", environmentString];
    [logString appendString:requestDescription];
    
    [logString appendString:@"\n************************************* Request End *************************************"];
    
    NSLog(@"%@", logString);
    
#endif
    
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject request:(NSURLRequest *)request error:(NSError *)error {
    
    NSMutableString *logString = [NSMutableString string];
#ifdef DEBUG
    
    [logString appendString:@"\n\n************************************* Response Start *************************************\n\n"];
    
    [logString appendFormat:@"Request URL:\n\t%@\n", request.URL];
    [logString appendFormat:@"response Object:\n\t%@\n", error ? responseObject : @"请自行检查"];
    [logString appendFormat:@"Error:\n\t%@\n", error ? : @"无"];
    
    [logString appendString:@"\n************************************* Response End *************************************\n\n"];

    NSLog(@"%@", logString);
    
#endif
}

+ (void)logDebugInfoWithCachedResponse:(RJURLResponse *)response apiName:(NSString *)apiName server:(id <RJServerProtocol>)server parameters:(id)parameters {
    NSMutableString *logString = [NSMutableString string];
    
#ifdef DEBUG

    NSString *environmentString = [self environmentDecription:server.environment];
    
    [logString appendString:@"\n\n************************************* Cache Response Start *************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Server:\t\t\t%@\n", NSStringFromClass([server class])];
    [logString appendFormat:@"Environment:\t%@\n", environmentString];
    [logString appendFormat:@"Parameters:\n\t%@\n", parameters];
    [logString appendFormat:@"response Object:\n\t%@\n", response ? @"请自行检查" : @"无数据"];
    
    [logString appendString:@"\n************************************* Cache Response End *************************************\n\n"];

    NSLog(@"%@", logString);
    
#endif
}

#pragma mark - Private Methods

+ (NSString *)requestDescription:(NSURLRequest *)request {
    NSMutableString *requestString = [NSMutableString string];
    [requestString appendFormat:@"HTTP URL:\n\t%@\n", request.URL];
    [requestString appendFormat:@"HTTP Header:\n\t%@\n", request.allHTTPHeaderFields];
//    [requestString appendFormat:@"Original Parameters:\n%@\n", request.rj_originRequestParameters];
    [requestString appendFormat:@"Actual Parameters:\n\t%@\n", request.rj_actualRequestParameters];
    [requestString appendFormat:@"HTTP Body:\n\t%@\n", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    return requestString;
}

+ (NSString *)environmentDecription:(RJServerAPIEnvironment)environment {
    NSString *environmentString = nil;
    switch (environment) {
        case RJServerAPIEnvironmentDevelop:
        {
            environmentString = @"开发";
        }
            break;
        case RJServerAPIEnvironmentTest:
        {
            environmentString = @"测试";
        }
            break;
        case RJServerAPIEnvironmentPreRelease:
        {
            environmentString = @"预发布";
        }
            break;
        case RJServerAPIEnvironmentRelease:
        {
            environmentString = @"发布";
        }
            break;
            
        default: {
            environmentString = @"开发";
        }
            break;
    }
    return environmentString;
}

@end
