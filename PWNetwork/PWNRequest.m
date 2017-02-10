//
//  PWNRequest.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNRequest.h"
#import "PWNRequest+Private.h"
#import "PWNReachability.h"
#import "PWNCenter.h"
#import "PWNUploadFormData.h"

NSString *PWNStringForRequestType(PWNRequestType type) {
    switch (type) {
        case PWNRequestNormal: return @"Normal";
        case PWNRequestDownload: return @"Download";
        case PWNRequestUpload: return @"Upload";
    }
    return nil;
}

@implementation PWNRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _requestType = PWNRequestNormal;
        _httpMethodType = PWNHTTPMethodGET;
        _requestSerializerType = PWNRequestSerializerRaw;
        _responseSerializerType = PWNResponseSerializerJSON;
        _timeoutInterval = PWNTimeoutIntervalForReachabilityStatus([PWNReachability sharedInstance].currentReachabilityStatus);
        _retryCount = 0;
        _retryTimeInterval = 2;
        
        _useGeneralHost = YES;
        _useGeneralHeaders = YES;
        _useGeneralParameters = YES;
        
        _uploadFormDatas = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:PWNReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public method

- (PWNRequest *)onSuccess:(PWNSuccessBlock)block {
    self.successBlock = block;
    return self;
}

- (PWNRequest *)onFailure:(PWNFailureBlock)block {
    self.failureBlock = block;
    return self;
}

- (PWNRequest *)onProgress:(PWNProgressBlock)block {
    self.progressBlock = block;
    return self;
}

- (PWNRequest *)onCompletion:(PWNCompletionBlock)block {
    self.completionBlock = block;
    return self;
}

- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    PWNUploadFormData *formData = [PWNUploadFormData new];
    formData.name = name;
    formData.fileURL = fileURL;
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData {
    PWNUploadFormData *formData = [PWNUploadFormData new];
    formData.name = name;
    formData.fileData = fileData;
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    PWNUploadFormData *formData = [PWNUploadFormData new];
    formData.name = name;
    formData.fileURL = fileURL;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    PWNUploadFormData *formData = [PWNUploadFormData new];
    formData.name = name;
    formData.fileData = fileData;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    [self.uploadFormDatas addObject:formData];
}

#pragma mark - Notification 

- (void)networkReachabilityDidChange:(NSNotification *)notification {
    self.timeoutInterval = PWNTimeoutIntervalForReachabilityStatus([PWNReachability sharedInstance].currentReachabilityStatus);
}

#pragma mark - Private method

- (void)m_cleanCallbackBlocks {
    _successBlock = nil;
    _failureBlock = nil;
    _completionBlock = nil;
    _progressBlock = nil;
}

@end
