//
//  NSURLRequest+RJNetworkingAdd.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/10.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "NSURLRequest+RJNetworkingAdd.h"
#import <ObjC/runtime.h>

static const char RJOriginRequestParametersKey = '\0';
static const char RJActualRequestParametersKey = '\0';

@implementation NSURLRequest (RJNetworkingAdd)

- (void)setRj_originRequestParameters:(id)originRequestParameters {
    objc_setAssociatedObject(self, &RJOriginRequestParametersKey, originRequestParameters, OBJC_ASSOCIATION_COPY);
}

- (id)rj_originRequestParameters {
    return objc_getAssociatedObject(self, &RJOriginRequestParametersKey);
}

- (void)setRj_actualRequestParameters:(id)actualRequestParameters {
    objc_setAssociatedObject(self, &RJActualRequestParametersKey, actualRequestParameters, OBJC_ASSOCIATION_COPY);
}

- (id)rj_actualRequestParameters {
    return objc_getAssociatedObject(self, &RJActualRequestParametersKey);
}


@end
