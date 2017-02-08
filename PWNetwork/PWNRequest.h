//
//  PWNRequest.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWNDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWNRequest : NSObject

/// 如果useGeneralHost是YES，且host是nil，则使用center的generalHost。
@property (nonatomic, copy, nullable) NSString *host;

/// 请求的api路径。
@property (nonatomic, copy, nullable) NSString *api;

/// 由host和api组成最终的url。如果该属性不是nil，则忽略host和api。
@property (nonatomic, copy, nullable) NSString *url;

/// 请求参数，如果useGeneralParameters是YES，则最终的parameters是center中的generalParameters和此属性的合集，如有相同，此属性kv会覆盖全局的。
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *parameters;

/// 请求参数，如果useGeneralHeaders是YES，则最终的parameters是center中的generalHeaders和此属性的合集，如有相同，此属性kv会覆盖全局的。
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *headers;

/// 默认是YES
@property (nonatomic, assign) BOOL useGeneralHost;

/// 默认是YES
@property (nonatomic, assign) BOOL useGeneralParameters;

/// 默认是YES
@property (nonatomic, assign) BOOL useGeneralHeaders;

/// 请求type，normal、upload和download，默认是PWNRequestNormal
@property (nonatomic, assign) PWNRequestType requestType;

/// HTTP方法，默认是PWNHTTPMethodGET
@property (nonatomic, assign) PWNHTTPMethodType httpMethodType;

/// request序列化类型，默认是PWNRequestSerializerRaw
@property (nonatomic, assign) PWNRequestSerializerType requestSerializerType;

/// response序列化类型，默认是PWNResponseSerializerJSON
@property (nonatomic, assign) PWNResponseSerializerType responseSerializerType;

/// 默认是60，根据不同网络状态进行变化（TODO）
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 错误发生时重试的次数，默认是0次。
@property (nonatomic, assign) NSUInteger retryCount;

/// 重试时间间隔，默认是2s。
@property (nonatomic, assign) NSTimeInterval retryTimeInterval;

/// 下载保存的地址
@property (nonatomic, copy, nullable) NSString *downloadSavePath;

#pragma mark - Call back

/// success回调
- (PWNRequest *)onSuccess:(nullable PWNSuccessBlock)block;

/// failure回调
- (PWNRequest *)onFailure:(nullable PWNFailureBlock)block;

/// progress回调
- (PWNRequest *)onProgress:(nullable PWNProgressBlock)block;

/// completion回调
- (PWNRequest *)onCompletion:(nullable PWNCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
