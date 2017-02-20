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
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"testImage" ofType:@"jpg"];
    
    
    self.r = [PWNRequest new];
    
    self.r.api = @"post";
    self.r.requestType = PWNRequestUpload;
    [self.r addFormDataWithName:@"image" fileName:@"testImage.jpg" mimeType:@"image/jpeg" fileURL:[NSURL fileURLWithPath:path]];
    
    [[[[self.r onSuccess:^(id  _Nullable responseObject) {
        
    }] onProgress:^(NSProgress * _Nonnull progress) {
        NSLog(@"%lf", progress.fractionCompleted);
    }] onFailure:^(NSError * _Nullable error) {
        
    }] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    [PWNDefaultCenter sendRequest:self.r];
}

@end
