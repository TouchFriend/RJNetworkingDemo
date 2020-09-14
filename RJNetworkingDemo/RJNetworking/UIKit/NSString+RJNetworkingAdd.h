//
//  NSString+RJNetworkingAdd.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/14.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RJNetworkingAdd)

/// md5加密
/// @param string 要加密的字符串
/// @return 加密后的字符串
+ (NSString *)rj_md5:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
