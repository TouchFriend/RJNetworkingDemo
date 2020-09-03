//
//  AppDelegate.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RJDemoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RJDemoViewController *vc = [[RJDemoViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
