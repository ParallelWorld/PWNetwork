//
//  PWNTestCase.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 20/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWNetwork.h"

@interface PWNTestCase : XCTestCase

@property (nonatomic, assign) NSTimeInterval networkTimeout;

- (void)waitForExpectationsWithCommonTimeout;
- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler;

@end
