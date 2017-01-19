//
//  PWNRequest.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNRequest.h"
#import "PWNRequestInternal.h"

@implementation PWNRequest

#pragma mark - Private method

- (void)m_cleanCallbackBlocks {
    _successBlock = nil;
    _failureBlock = nil;
    _completionBlock = nil;
    _progressBlock = nil;
}

@end
