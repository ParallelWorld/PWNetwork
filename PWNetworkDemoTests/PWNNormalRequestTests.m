//
//  PWNNormalRequestTests.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 20/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNTestCase.h"

@interface PWNNormalRequestTests : PWNTestCase

@end

@implementation PWNNormalRequestTests

- (void)testGET {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request with GET method should succeed."];
    
    PWNRequest *r = [PWNRequest new];
    r.api = @"get";
    r.httpMethodType = PWNHTTPMethodGET;
    [r onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        XCTAssertNotNil(responseObject);
        [expectation fulfill];
    }];
    
    [PWNDefaultCenter sendRequest:r];
    
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testGETWithParameters {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request with GET method should succeed."];
    
    PWNRequest *r = [PWNRequest new];
    r.url = @"http://httpbin.org/get";
    r.parameters = @{@"key": @"value"};
    r.httpMethodType = PWNHTTPMethodGET;
    r.useGeneralParameters = NO;
    r.useGeneralHeaders = NO;
    
    [[[r onSuccess:^(id  _Nullable responseObject) {
        XCTAssertTrue([responseObject[@"args"][@"key"] isEqualToString:@"value"]);
    }] onFailure:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        XCTAssertTrue([responseObject[@"args"][@"key"] isEqualToString:@"value"]);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [PWNDefaultCenter sendRequest:r];


    [self waitForExpectationsWithCommonTimeout];
}

//- (void)testCancelRunningRequest {
//    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Request should fail due to manually cancelled."];
//    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Cancel block should be called."];
//    
//    NSUInteger identifier = [[PWNCenter defaultCenter] sendRequest:^(PWNRequest * _Nonnull request) {
//        request.api = @"/delay/10";
//        request.httpMethodType = PWNHTTPMethodGET;
//    } onProgress:nil onSuccess:^(id  _Nullable responseObject) {
//        XCTAssertNil(responseObject);
//    } onFailure:^(NSError * _Nullable error) {
//        XCTAssertNotNil(error);
//        XCTAssertTrue(error.code == NSURLErrorCancelled);
//    } onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        XCTAssertNil(responseObject);
//        XCTAssertNotNil(error);
//        XCTAssertTrue(error.code == NSURLErrorCancelled);
//        [expectation1 fulfill];
//    }];
//    
//    sleep(5);
//    
//    [[PWNCenter defaultCenter] cancelRequest:identifier onCancel:^(PWNRequest * _Nullable request) {
//        XCTAssertNotNil(request);
//        XCTAssertTrue([request.url isEqualToString:@"http://httpbin.org/delay/10"]);
//        [expectation2 fulfill];
//    }];
//    
//    [self waitForExpectationsWithCommonTimeout];
//}

@end
