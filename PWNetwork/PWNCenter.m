//
//  PWNCenter.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNCenter.h"

#import "PWNRequest.h"
#import "PWNRequest+Private.h"
#import "PWNEngine.h"
#import "PWNCenter+Private.h"
#import "PWNReachability.h"


NSTimeInterval PWNTimeoutIntervalForReachabilityStatus(PWNReachabilityStatus status) {
    switch (status) {
        case PWNReachabilityStatusUnknown: return 30;
        case PWNReachabilityStatusNotReachable: return 0;
        case PWNReachabilityStatusReachableViaWiFi: return 20;
        case PWNReachabilityStatusReachableViaWWAN: return 50;
    }
}


@implementation PWNCenter

#pragma mark - Public method

+ (instancetype)defaultCenter {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendRequest:(PWNRequest *)request {
    [self m_processRequest:request];
    [self m_sendRequest:request];
}

- (void)cancelRequest:(PWNRequest *)request {
    [[PWNEngine sharedEngine] cancelRequest:request];
}

#pragma mark - Private method

- (void)m_processRequest:(PWNRequest *)request {
    // 处理headers
    if (request.useGeneralHeaders) {
        NSMutableDictionary *headers = [NSMutableDictionary new];
        if (self.generalHeaders) [headers addEntriesFromDictionary:self.generalHeaders];
        if (request.headers) [headers addEntriesFromDictionary:request.headers];
        request.entireHeaders = headers;
    } else {
        request.entireHeaders = request.headers;
    }
    
    // 处理parameters
    if (request.useGeneralParameters) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        if (self.generalParameters) [parameters addEntriesFromDictionary:self.generalParameters];
        if (request.parameters) [parameters addEntriesFromDictionary:request.parameters];
        request.entireParameters = parameters;
    } else {
        request.entireParameters = request.parameters;
    }
    
    // 处理url
    if (request.url.length == 0) {
        if (request.host.length == 0 && request.useGeneralHost && self.generalHost.length > 0) {
            request.host = self.generalHost;
        }
        if (request.api.length > 0) {
            NSURL *baseURL = [NSURL URLWithString:request.host];
            request.url = [[NSURL URLWithString:request.api relativeToURL:baseURL] absoluteString];
        } else {
            request.url = request.host;
        }
    }
    
    PWNAssert(request.url.length > 0, @"request的url不能为空.");
}

- (void)m_sendRequest:(PWNRequest *)request {
    [[PWNEngine sharedEngine] sendRequest:request completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            [self m_failureWithError:error forRequest:request];
        } else {
            [self m_successWithResponse:responseObject forRequest:request];
        }
    }];
}

- (void)m_failureWithError:(NSError *)error forRequest:(PWNRequest *)request {
    // 请求失败重试
    if (request.retryCount > 0) {
        request.retryCount--;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(request.retryTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self m_sendRequest:request];
        });
        return;
    }
    
    [self m_executeFailureBlockWithError:error forRequest:request];
}

- (void)m_successWithResponse:(id)responseObject forRequest:(PWNRequest *)request {
    [self m_executeSuccessBlockWithResponse:responseObject forRequest:request];
}

- (void)m_executeFailureBlockWithError:(NSError *)error forRequest:(PWNRequest *)request {
    PWN_SAFE_BLOCK(request.failureBlock, error);
    PWN_SAFE_BLOCK(request.completionBlock, nil, error);
}

- (void)m_executeSuccessBlockWithResponse:(id)responseObject forRequest:(PWNRequest *)request {
    PWN_SAFE_BLOCK(request.successBlock, responseObject);
    PWN_SAFE_BLOCK(request.completionBlock, responseObject, nil);
}

@end
