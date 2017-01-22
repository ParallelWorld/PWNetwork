//
//  NSURLSessionTask+PWNRequest.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 22/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWNRequest;

@interface NSURLSessionTask (PWNRequest)

@property (nonatomic, strong) PWNRequest *pwn_request;

@end
