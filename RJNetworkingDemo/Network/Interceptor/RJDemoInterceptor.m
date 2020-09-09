//
//  RJDemoInterceptor.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/9.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoInterceptor.h"

@implementation RJDemoInterceptor

- (BOOL)manager:(RJBaseAPIManager *)manager shouldCallAPIWithParameters:(id)parameters {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)manager:(RJBaseAPIManager *)manager afterCallAPIWithParameters:(id)parameters {
    NSLog(@"%s", __func__);
}

- (void)manager:(RJBaseAPIManager *)manager didReceiveResponse:(RJURLResponse *)response {
    NSLog(@"%s", __func__);
}

- (BOOL)manager:(RJBaseAPIManager *)manager beforePerformSuccessWithResponse:(RJURLResponse *)response {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)manager:(RJBaseAPIManager *)manager afterPerformSuccessWithResponse:(RJURLResponse *)response {
    NSLog(@"%s", __func__);
}

- (BOOL)manager:(RJBaseAPIManager *)manager beforePerformFailWithResponse:(RJURLResponse *)response {
    NSLog(@"%s", __func__);
    return YES;
}

- (void)manager:(RJBaseAPIManager *)manager afterPerformFailWithResponse:(RJURLResponse *)response {
    NSLog(@"%s", __func__);
}

@end
