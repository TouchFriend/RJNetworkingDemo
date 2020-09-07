//
//  RJURLResponse.h
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJURLResponse : NSObject

/// <#Desription#>
@property (nonatomic, strong) id responseObject;
/// <#Desription#>
@property (nonatomic, assign) NSInteger requestID;
/// <#Desription#>
@property (nonatomic, strong) NSURLRequest *request;
/// <#Desription#>
@property (nonatomic, strong) NSError *error;





@end

NS_ASSUME_NONNULL_END
