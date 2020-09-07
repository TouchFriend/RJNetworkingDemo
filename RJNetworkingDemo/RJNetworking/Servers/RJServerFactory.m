//
//  RJServerFactory.m
//  RJNetworkingDemo
//
//  Created by TouchWorld on 2020/9/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJServerFactory.h"

@interface RJServerFactory ()

/// <#Desription#>
@property (nonatomic, strong) NSMutableDictionary *serverStorage;


@end

@implementation RJServerFactory

+ (instancetype)sharedInstance {
    static RJServerFactory *factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[RJServerFactory alloc] init];
    });
    return factory;
}

#pragma mark - Public Methods

- (id <RJServerProtocol>)serverWithIdentifier:(NSString *)identifier {
    if (!self.serverStorage[identifier]) {
        self.serverStorage[identifier] = [self newServerWithIdentifier:identifier];
    }
    return self.serverStorage[identifier];
}

#pragma mark - Private Methods

- (id <RJServerProtocol>)newServerWithIdentifier:(NSString *)identifier {
    Class serverClass = NSClassFromString(identifier);
    return [[serverClass alloc] init];
}

#pragma mark - Property Methods

- (NSMutableDictionary *)serverStorage {
    if (!_serverStorage) {
        _serverStorage = [NSMutableDictionary dictionary];
    }
    return _serverStorage;
}

@end
