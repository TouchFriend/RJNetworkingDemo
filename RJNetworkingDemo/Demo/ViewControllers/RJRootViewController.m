//
//  RJRootViewController.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/7.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJRootViewController.h"
#import "RJDemoViewController.h"

@interface RJRootViewController ()

@end

@implementation RJRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    RJDemoViewController *vc = [[RJDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
