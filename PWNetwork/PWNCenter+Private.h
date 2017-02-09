//
//  PWNCenterInternal.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWNCenter.h"

NS_ASSUME_NONNULL_BEGIN

@class PWNRequest;

@interface PWNCenter ()

@property (nonatomic, copy, nullable) PWNRequestProcessBlock requestProcessHandler;
@property (nonatomic, copy, nullable) PWNResponseProcessBlock responseProcessHandler;

/// 对原始的request进行处理
- (void)m_processRequest:(nullable PWNRequest *)request;

/// 把request移交给PWNEngine发送
- (void)m_sendRequest:(nullable PWNRequest *)request;

- (void)m_successWithResponse:(nullable id)responseObject forRequest:(nullable PWNRequest *)request;
- (void)m_failureWithError:(nullable NSError *)error forRequest:(nullable PWNRequest *)request;
- (void)m_executeSuccessBlockWithResponse:(nullable id)responseObject forRequest:(nullable PWNRequest *)request;
- (void)m_executeFailureBlockWithError:(nullable NSError *)error forRequest:(nullable PWNRequest *)request;

@end

NS_ASSUME_NONNULL_END
