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

@end

@implementation RJBaseAPIManager

- (NSInteger)loadDataWithParameters:(id)parameters {
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
    
    NSNumber *requestID = [[RJAPIProxy sharedInstance] callApiWithRequest:request];
    NSLog(@"requestID:%@", requestID);
    return 0;
}

#pragma mark - Property Methods

- (RJAPIManagerRequestType)requestType {
    return RJAPIManagerRequestTypePost;
}

- (RJAPIManagerRequestSerializerType)requestSerializerType {
    return RJAPIManagerRequestSerializerTypeHTTP;
}

@end
