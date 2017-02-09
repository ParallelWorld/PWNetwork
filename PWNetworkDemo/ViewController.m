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
@property (nonatomic, strong) PWNRequest *r;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.r = [PWNRequest new];
    self.r.api = @"get";
    self.r.parameters = @{@"key": @"value",
                     @"key1": @"中文value"};
    self.r.httpMethodType = PWNHTTPMethodGET;
    self.r.useGeneralParameters = NO;
    self.r.useGeneralHeaders = NO;
    
    [[[[self.r onSuccess:^(id  _Nullable responseObject) {
        
    }] onFailure:^(NSError * _Nullable error) {
        
    }] onProgress:^(NSProgress * _Nonnull progress) {
        
    }] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    [PWNDefaultCenter sendRequest:self.r];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PWNDefaultCenter sendRequest:self.r];
    });
}

@end
