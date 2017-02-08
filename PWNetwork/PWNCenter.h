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

#define PWNDefaultCenter [PWNCenter defaultCenter]

NS_ASSUME_NONNULL_BEGIN

@interface PWNCenter : NSObject

/// 默认的center，也可以定义自己的center，比如有多个业务场景或者多个host的情况下
+ (instancetype)defaultCenter;

/// 公共host
@property (nonatomic, copy, nullable) NSString *generalHost;

/// 公共parameter
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *generalParameters;

/// 公共header
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

/// 发送request
- (void)sendRequest:(PWNRequest *)request;

/// 取消request
- (void)cancelRequest:(PWNRequest *)request;

@end

NS_ASSUME_NONNULL_END
