//
//  PWNEngine.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNEngine.h"

#import "AFNetworking.h"
#import "PWNRequest.h"
#import "PWNRequestInternal.h"
#import "PWNEngineInternal.h"
#import "NSURLSessionTask+PWNRequest.h"

@implementation PWNEngine

+ (instancetype)sharedEngine {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

//NSError *serializationError = nil;
//NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
//if (serializationError) {
//    if (failure) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wgnu"
//        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
//            failure(nil, serializationError);
//        });
//#pragma clang diagnostic pop
//    }
//    
//    return nil;
//}

//__block NSURLSessionDataTask *dataTask = nil;
//dataTask = [self dataTaskWithRequest:request
//                      uploadProgress:uploadProgress
//                    downloadProgress:downloadProgress
//                   completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//                       if (error) {
//                           if (failure) {
//                               failure(dataTask, error);
//                           }
//                       } else {
//                           if (success) {
//                               success(dataTask, responseObject);
//                           }
//                       }
//                   }];


- (NSUInteger)sendRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completionHandler {
    NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest = [self.sessionManager.requestSerializer requestWithMethod:HTTP_METHOD_NAME_FOR_TYPE(request.httpMethodType) URLString:request.url parameters:request.parameters error:&serializationError];
    if (serializationError) {
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, serializationError);
            });
        }
        return 0;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completionHandler) {
            completionHandler(responseObject, error);
        }
    }];
    
    dataTask.pwn_request = request;
    
    request.identifier = dataTask.taskIdentifier;
    
    [dataTask resume];

    return request.identifier;
}

- (PWNRequest *)cancelRequestByIdentifier:(NSUInteger)identifier {
    PWNRequest *request = nil;
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        if (task.taskIdentifier == identifier) {
            request = task.pwn_request;
            [task cancel];
            break;
        }
    }
    return request;
}

@end
