//
//  PWNRequestTests.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWNetwork.h"

@interface PWNRequestTests : XCTestCase

@end

@implementation PWNRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGET {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request with GET method should succeed."];
    PWNCenter *center = [PWNCenter defaultCenter];
    [center sendRequest:^(PWNRequest * _Nonnull request) {
        request.host = @"http://httpbin.org";
        request.api = @"get";
        request.httpMethodType = PWNHTTPMethodGET;
    } onSuccess:^(id  _Nullable responseObject) {
        XCTAssertNotNil(responseObject);
        [expectation fulfill];
    } onFailure:^(NSError * _Nullable error) {
        
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testGETWithParameters {
    
}

- (void)testPOSTWithForm {
    
}

@end
