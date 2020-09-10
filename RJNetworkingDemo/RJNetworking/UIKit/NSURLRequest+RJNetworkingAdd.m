//
//  NSURLRequest+RJNetworkingAdd.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "NSURLRequest+RJNetworkingAdd.h"
#import <ObjC/runtime.h>

static void *RJOriginRequestParametersKey = &RJOriginRequestParametersKey;
static void *RJActualRequestParametersKey = &RJActualRequestParametersKey;

@implementation NSURLRequest (RJNetworkingAdd)

- (void)setOriginRequestParameters:(id)originRequestParameters {
    objc_setAssociatedObject(self, RJOriginRequestParametersKey, originRequestParameters, OBJC_ASSOCIATION_COPY);
}

- (id)originRequestParameters {
    return objc_getAssociatedObject(self, RJOriginRequestParametersKey);
}

- (void)setActualRequestParameters:(id)actualRequestParameters {
    objc_setAssociatedObject(self, RJActualRequestParametersKey, actualRequestParameters, OBJC_ASSOCIATION_COPY);
}

- (id)actualRequestParameters {
    return objc_getAssociatedObject(self, RJActualRequestParametersKey);
}


@end
