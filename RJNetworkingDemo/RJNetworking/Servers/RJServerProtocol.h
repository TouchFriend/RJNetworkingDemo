//
//  RJServerProtocol.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJNetworkingConst.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RJServerProtocol <NSObject>

/// 服务器环境
@property (nonatomic, assign) RJServerAPIEnvironment environment;
/// 基本URL
@property (nonatomic, copy) NSString *baseURL;


@end

NS_ASSUME_NONNULL_END
