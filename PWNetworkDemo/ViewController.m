//
//  ViewController.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "ViewController.h"
#import "PWNetwork.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PWNRequest *r = [PWNRequest new];
    r.api = @"get";
    r.parameters = @{@"key": @"value",
                     @"key1": @"中文value"};
    r.httpMethodType = PWNHTTPMethodGET;
    r.useGeneralParameters = NO;
    r.useGeneralHeaders = NO;
    
    [[[[r onSuccess:^(id  _Nullable responseObject) {
        
    }] onFailure:^(NSError * _Nullable error) {
        
    }] onProgress:^(NSProgress * _Nonnull progress) {
        
    }] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    [PWNDefaultCenter sendRequest:r];
}

@end
