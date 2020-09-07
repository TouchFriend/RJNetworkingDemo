//
//  RJDemoViewController.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoViewController.h"
#import "RJDemoAPIManager.h"

@interface RJDemoViewController () <RJAPIManagerCallbackDelegate>

/// <#Desription#>
@property (nonatomic, strong) RJDemoAPIManager *demoAPIManager;


@end

@implementation RJDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.demoAPIManager loadDataWithParameters:nil];
}

#pragma mark - RJAPIManagerCallbackDelegate Methods

- (void)managerCallAPIDidSuccess:(RJBaseAPIManager *)manager {
    NSLog(@"成功");
}

- (void)managerCallAPIDidFailed:(RJBaseAPIManager *)manager {
    NSLog(@"失败");
}

#pragma mark - Property Methods

- (RJDemoAPIManager *)demoAPIManager {
    if (!_demoAPIManager) {
        _demoAPIManager = [[RJDemoAPIManager alloc] init];
        _demoAPIManager.delegate = self;
    }
    return _demoAPIManager;;
}

@end
