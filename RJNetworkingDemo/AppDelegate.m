//
//  AppDelegate.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RJDemoViewController.h"
#import "RJRootViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RJRootViewController *vc = [[RJRootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
