//
//  RJDemoViewController.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDemoViewController.h"
#import "RJNetworking.h"
#import "RJDemoAPIManager.h"
#import "RJDemoDataReformer.h"

@interface RJDemoViewController () <RJAPIManagerCallbackDelegate>

/// <#Desription#>
@property (nonatomic, strong) RJDemoAPIManager *demoAPIManager;
/// <#Desription#>
@property (nonatomic, assign) NSInteger requestID;
/// 整流器
@property (nonatomic, strong) RJDemoDataReformer *demoDataReformer;


@end

@implementation RJDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *startBtn = [self getTempButton];
    [self.view addSubview:startBtn];
    startBtn.bounds = CGRectMake(0, 0, 100, 50);
    startBtn.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [self getTempButton];
    [self.view addSubview:stopBtn];
    stopBtn.bounds = CGRectMake(0, 0, 100, 50);
    stopBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (UIButton *)getTempButton {
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor orangeColor];
    [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    return tempBtn;
}

- (void)startBtnClick {
    self.demoAPIManager.successBlock = ^(RJBaseAPIManager * _Nonnull apiManager) {
        NSLog(@"成功闭包");
    };
    self.demoAPIManager.failBlock = ^(RJBaseAPIManager * _Nonnull apiManager) {
        NSLog(@"失败闭包");
    };
    self.requestID = [self.demoAPIManager loadDataWithUserKey:@"test"];
}

- (void)stopBtnClick {
    [self.demoAPIManager cancelRequestWithRequestID:self.requestID];
}

#pragma mark - RJAPIManagerCallbackDelegate Methods

- (void)managerCallAPIDidSuccess:(RJBaseAPIManager *)manager {
    NSLog(@"成功代理:%@", [manager fetchDataWithReformer:self.demoDataReformer]);
}

- (void)managerCallAPIDidFailed:(RJBaseAPIManager *)manager {
    NSLog(@"失败代理：%@\n%@", [manager fetchDataWithReformer:nil], manager.response.error);
}

#pragma mark - Property Methods

- (RJDemoAPIManager *)demoAPIManager {
    if (!_demoAPIManager) {
        _demoAPIManager = [[RJDemoAPIManager alloc] init];
        _demoAPIManager.delegate = self;
        _demoAPIManager.cachePolicy = RJAPIManagerCachePolicyNoCache;
    }
    return _demoAPIManager;;
}

- (RJDemoDataReformer *)demoDataReformer {
    if (!_demoDataReformer) {
        _demoDataReformer = [[RJDemoDataReformer alloc] init];
    }
    return _demoDataReformer;
}

@end
