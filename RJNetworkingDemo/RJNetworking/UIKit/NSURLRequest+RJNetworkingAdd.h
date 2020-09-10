//
//  NSURLRequest+RJNetworkingAdd.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (RJNetworkingAdd)

/// 原有的请求参数
@property (nonatomic, copy) id originRequestParameters;
/// 实际的请求参数
@property (nonatomic, copy) id actualRequestParameters;


@end

NS_ASSUME_NONNULL_END
