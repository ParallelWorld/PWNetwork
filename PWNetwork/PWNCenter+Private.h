//
//  PWNCenterInternal.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWNCenter.h"

@class PWNRequest;

@interface PWNCenter ()

/// 对原始的request进行处理
- (void)m_processRequest:(PWNRequest *)request;

/// 把request移交给PWNEngine发送
- (void)m_sendRequest:(PWNRequest *)request;

- (void)m_successWithResponse:(id)responseObject forRequest:(PWNRequest *)request;
- (void)m_failureWithError:(NSError *)error forRequest:(PWNRequest *)request;
- (void)m_executeSuccessBlockWithResponse:(id)responseObject forRequest:(PWNRequest *)request;
- (void)m_executeFailureBlockWithError:(NSError *)error forRequest:(PWNRequest *)request;

@end
