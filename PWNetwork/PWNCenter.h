//
//  PWNCenter.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWNDefines.h"

@class PWNRequest, PWNCenterConfig;

NS_ASSUME_NONNULL_BEGIN

@interface PWNCenter : NSObject

/// 默认的center，也可以定义自己的center，比如有多个业务场景或者多个host的情况下
+ (instancetype)defaultCenter;

/// 配置center
- (void)setupConfig:(void(^)(PWNCenterConfig *config))block;

- (NSUInteger)sendRequest:(PWNRequestConfigBlock)config
             onCompletion:(nullable PWNCompletionBlock)completion;

- (NSUInteger)sendRequest:(PWNRequestConfigBlock)config
                onSuccess:(nullable PWNSuccessBlock)success
                onFailure:(nullable PWNFailureBlock)failure;

- (NSUInteger)sendRequest:(PWNRequestConfigBlock)config
               onProgress:(nullable PWNProgressBlock)progress
                onSuccess:(nullable PWNSuccessBlock)success
                onFailure:(nullable PWNFailureBlock)failure
             onCompletion:(nullable PWNCompletionBlock)completion;

- (void)cancelRequest:(NSUInteger)identifier;
- (void)cancelRequest:(NSUInteger)identifier
             onCancel:(nullable PWNCancelBlock)cancel;

@end

NS_ASSUME_NONNULL_END
