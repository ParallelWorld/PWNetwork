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

@interface PWNEngine : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// engine单例
+ (instancetype)sharedEngine;

/// 发送请求
- (void)sendRequest:(PWNRequest *)request completionHandler:(nullable PWNCompletionHandler)completionHandler;

/// 取消请求
- (void)cancelRequest:(PWNRequest *)request;

@end

/// request发送后的通知
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidStartNotification;

/// request完成后的通知
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteNotification;

/// userInfo的key，指向序列化response的serializer
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteResponseSerializerKey;

/// userInfo的key，指向download task的下载地址
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteAssetPathKey;

/// userInfo的key，指向task的raw response data
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteResponseDataKey;

/// userInfo的key，指向task的错误或者response序列化时的错误
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteErrorKey;

/// userInfo的key，指向序列化后的response data
FOUNDATION_EXPORT NSString * const PWNetworkRequestDidCompleteSerializedResponseKey;

NS_ASSUME_NONNULL_END
