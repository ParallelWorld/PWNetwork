//
//  PWNTestCase.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 20/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNTestCase.h"

@implementation PWNTestCase

- (void)setUp {
    [super setUp];
    
    self.networkTimeout = 20;
    PWNDefaultCenter.generalHost = @"http://httpbin.org";
    PWNDefaultCenter.generalParameters = @{@"global_param": @"global param value"};
    PWNDefaultCenter.generalHeaders = @{@"global_header": @"global header value"};
    
    [PWNLogger sharedLogger].level = PWNLoggerLevelDebug;
    [[PWNLogger sharedLogger] startLogging];
}

- (void)waitForExpectationsWithCommonTimeout {
    [self waitForExpectationsWithCommonTimeoutUsingHandler:nil];
}

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler {
    [self waitForExpectationsWithTimeout:self.networkTimeout handler:handler];
}

@end
