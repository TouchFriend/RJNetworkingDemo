//
//  RJServerFactory.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJServerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJServerFactory : NSObject

/// 单例
+ (instancetype)sharedInstance;

/// 获取标识符对应的服务器对象
/// @param identifier 标识符（服务器的类名）
- (id <RJServerProtocol>)serverWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
