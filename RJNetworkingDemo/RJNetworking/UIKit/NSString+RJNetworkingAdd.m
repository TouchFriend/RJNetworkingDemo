//
//  NSString+RJNetworkingAdd.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/14.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "NSString+RJNetworkingAdd.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RJNetworkingAdd)

+ (NSString *)rj_md5:(NSString *)string {
    NSParameterAssert(string != nil && string.length > 0);
    
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
