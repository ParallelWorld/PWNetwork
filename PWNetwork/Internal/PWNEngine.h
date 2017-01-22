//
//  PWNEngine.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWNRequest;

NS_ASSUME_NONNULL_BEGIN

typedef void (^PWNCompletionHandler)(id _Nullable responseObject, NSError * _Nullable error);

/// 单纯的网络请求，不涉及网络请求的配置管理
@interface PWNEngine : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedEngine;

- (NSUInteger)sendRequest:(PWNRequest *)request
        completionHandler:(nullable PWNCompletionHandler)completionHandler;

- (PWNRequest *)cancelRequestByIdentifier:(NSUInteger)identifier;

@end

NS_ASSUME_NONNULL_END
