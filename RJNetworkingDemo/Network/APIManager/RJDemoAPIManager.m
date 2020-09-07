//
//  RJDemoAPIManager.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoAPIManager.h"
#import "RJDemoServer.h"

@implementation RJDemoAPIManager

- (NSString *)urlPath {
    return @"public/characters";
}

- (NSString *)serverIdentifier {
    return NSStringFromClass([RJDemoServer class]);
}

- (RJAPIManagerRequestType)requestType {
    return RJAPIManagerRequestTypeGet;
}

- (RJAPIManagerRequestSerializerType)requestSerializerType {
    return RJAPIManagerRequestSerializerTypeHTTP;
}

@end
