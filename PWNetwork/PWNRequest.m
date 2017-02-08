//
//  PWNRequest.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNRequest.h"
#import "PWNRequest+Private.h"

@implementation PWNRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _requestType = PWNRequestNormal;
        _httpMethodType = PWNHTTPMethodGET;
        _requestSerializerType = PWNRequestSerializerRaw;
        _responseSerializerType = PWNResponseSerializerJSON;
        _timeoutInterval = 60.0;
        _retryCount = 0;
        _retryTimeInterval = 2;
        
        _useGeneralHost = YES;
        _useGeneralHeaders = YES;
        _useGeneralParameters = YES;
    }
    return self;
}

#pragma mark - Public method

- (PWNRequest *)onSuccess:(PWNSuccessBlock)block {
    self.successBlock = block;
    return self;
}

- (PWNRequest *)onFailure:(PWNFailureBlock)block {
    self.failureBlock = block;
    return self;
}

- (PWNRequest *)onProgress:(PWNProgressBlock)block {
    self.progressBlock = block;
    return self;
}

- (PWNRequest *)onCompletion:(PWNCompletionBlock)block {
    self.completionBlock = block;
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
