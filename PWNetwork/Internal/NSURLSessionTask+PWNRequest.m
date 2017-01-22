//
//  NSURLSessionTask+PWNRequest.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 22/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "NSURLSessionTask+PWNRequest.h"

#import <objc/runtime.h>
#import "PWNRequest.h"

@implementation NSURLSessionTask (PWNRequest)

- (PWNRequest *)pwn_request {
    return objc_getAssociatedObject(self, @selector(pwn_request));
}

- (void)setPwn_request:(PWNRequest *)pwn_request {
    objc_setAssociatedObject(self, @selector(pwn_request), pwn_request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
