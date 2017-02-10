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
    
    self.r.url = @"http://pic.qiantucdn.com/00/92/26/19bOOOPIC1d.jpg";
    self.r.api = @"image/png";
    self.r.requestType = PWNRequestDownload;
//    self.r.downloadFileDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    self.r.downloadFileName = @"test.png";
    
    [[[[self.r onSuccess:^(id  _Nullable responseObject) {
        
    }] onProgress:^(NSProgress * _Nonnull progress) {
        NSLog(@"%lf", progress.fractionCompleted);
    }] onFailure:^(NSError * _Nullable error) {
        
    }] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    [PWNDefaultCenter sendRequest:self.r];
}

@end
