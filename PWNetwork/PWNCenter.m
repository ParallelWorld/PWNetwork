//
//  PWNCenter.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNCenter.h"

#import "PWNRequest.h"
#import "PWNRequestInternal.h"
#import "PWNEngine.h"
#import "PWNCenterConfig.h"
#import "PWNCenterInternal.h"


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

- (void)setupConfig:(void (^)(PWNCenterConfig * _Nonnull))block {
    PWNCenterConfig *config = [PWNCenterConfig new];
    PWN_SAFE_BLOCK(block, config);
    self.config = config;
}

- (NSUInteger)sendRequest:(PWNRequestConfigBlock)config onSuccess:(PWNSuccessBlock)success onFailure:(PWNFailureBlock)failure {
    return [self sendRequest:config onProgress:nil onSuccess:success onFailure:failure onCompletion:nil];
}

- (NSUInteger)sendRequest:(PWNRequestConfigBlock)config onProgress:(PWNProgressBlock)progress onSuccess:(PWNSuccessBlock)success onFailure:(PWNFailureBlock)failure onCompletion:(PWNCompletionBlock)completion {
    PWNRequest *request = [PWNRequest new];
    PWN_SAFE_BLOCK(config, request);
    [self m_processRequest:request onProgress:progress onSuccess:success onFailure:failure onCompletion:completion];
    return [self m_sendRequest:request];
}

+ (void)cancelRequest:(NSUInteger)identifier {
    [[PWNEngine sharedEngine] cancelRequestByIdentifier:identifier];
}

#pragma mark - Private method

- (NSUInteger)m_sendRequest:(PWNRequest *)request {
    return [[PWNEngine sharedEngine] sendRequest:request completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            [self m_failureWithError:error forRequest:request];
        } else {
            [self m_successWithResponse:responseObject forRequest:request];
        }
    }];
}

- (void)m_processRequest:(PWNRequest *)request onProgress:(PWNProgressBlock)progress onSuccess:(PWNSuccessBlock)success onFailure:(PWNFailureBlock)failure onCompletion:(PWNCompletionBlock)completion {
    // 处理回调
    request.successBlock = success;
    request.failureBlock = failure;
    request.progressBlock = progress;
    request.completionBlock = completion;
    
    // 处理headers
    if (request.useGeneralHeaders && self.config.generalHeaders) {
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers addEntriesFromDictionary:self.config.generalHeaders];
        if (request.headers) {
            [headers addEntriesFromDictionary:request.headers];
        }
        request.headers = headers;
    }
    
    // 处理parameters
    if (request.useGeneralParameters && self.config.generalParameters) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters addEntriesFromDictionary:self.config.generalParameters];
        if (request.parameters) {
            [parameters addEntriesFromDictionary:request.parameters];
        }
        request.parameters = parameters;
    }
    
    // 处理url
    if (request.url.length == 0) {
        if (request.host.length == 0 && request.useGeneralHost && self.config.generalHost.length > 0) {
            request.host = self.config.generalHost;
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

- (void)m_executeFailureBlockWithError:(NSError *)error forRequest:(PWNRequest *)request {
    PWN_SAFE_BLOCK(request.failureBlock, error);
    PWN_SAFE_BLOCK(request.completionBlock, nil, error);
    [request m_cleanCallbackBlocks];
}

- (void)m_executeSuccessBlockWithResponse:(id)responseObject forRequest:(PWNRequest *)request {
    PWN_SAFE_BLOCK(request.successBlock, responseObject);
    PWN_SAFE_BLOCK(request.completionBlock, responseObject, nil);
    [request m_cleanCallbackBlocks];
}

- (void)m_failureWithError:(NSError *)error forRequest:(PWNRequest *)request {
    [self m_executeFailureBlockWithError:error forRequest:request];
}

- (void)m_successWithResponse:(id)responseObject forRequest:(PWNRequest *)request {
    [self m_executeSuccessBlockWithResponse:responseObject forRequest:request];
}

@end
