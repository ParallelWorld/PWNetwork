//
//  PWNRequest.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNRequest.h"
#import "PWNRequestInternal.h"

@implementation PWNRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _httpMethodType = PWNHTTPMethodGET;
        _timeoutInterval = 60.0;
        
        _useGeneralHost = YES;
        _useGeneralHeaders = YES;
        _useGeneralParameters = YES;
    }
    return self;
}

#pragma mark - Private method

- (void)m_cleanCallbackBlocks {
    _successBlock = nil;
    _failureBlock = nil;
    _completionBlock = nil;
    _progressBlock = nil;
}

@end
