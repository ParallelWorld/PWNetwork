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
#import "AFNetworkActivityIndicatorManager.h"
#import "PWNReachability.h"
#import "PWNUploadFormData.h"


NSString * const PWNetworkRequestDidStartNotification = @"PWNetworkRequestDidStartNotification";

NSString * const PWNetworkRequestDidCompleteNotification = @"PWNetworkRequestDidCompleteNotification";

NSString * const PWNetworkRequestDidCompleteResponseSerializerKey = @"PWNetworkRequestDidCompleteResponseSerializerKey";

NSString * const PWNetworkRequestDidCompleteAssetPathKey = @"PWNetworkRequestDidCompleteAssetPathKey";

NSString * const PWNetworkRequestDidCompleteResponseDataKey = @"PWNetworkRequestDidCompleteResponseDataKey";

NSString * const PWNetworkRequestDidCompleteErrorKey = @"PWNetworkRequestDidCompleteErrorKey";

NSString * const PWNetworkRequestDidCompleteSerializedResponseKey = @"PWNetworkRequestDidCompleteSerializedResponseKey";

static NSUInteger PWNMaxConcurrentOperationCountForReachabilityStatus(PWNReachabilityStatus status) {
    switch (status) {
        case PWNReachabilityStatusUnknown: return 35;
        case PWNReachabilityStatusNotReachable: return 10;
        case PWNReachabilityStatusReachableViaWiFi: return 35;
        case PWNReachabilityStatusReachableViaWWAN: return 15;
    }
}

NSString *PWNStringFromDate(NSDate *date) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [dateString stringByAppendingString:[NSString stringWithFormat:@"-%ld", (long)date.timeIntervalSince1970]];
}

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
        _afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
        _afJSONRequestSerializer = [AFJSONRequestSerializer serializer];
        _afPListRequestSerializer = [AFPropertyListRequestSerializer serializer];
        
        _afHTTPResponseSerializer = [AFHTTPResponseSerializer serializer];
        _afJSONResponseSerializer = [AFJSONResponseSerializer serializer];
        _afXMLResponseSerializer = [AFXMLParserResponseSerializer serializer];
        _afPListResponseSerializer = [AFPropertyListResponseSerializer serializer];
        
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = _afHTTPRequestSerializer;
        _sessionManager.responseSerializer = _afHTTPResponseSerializer;
        
        // 设置最大并发量
        _sessionManager.operationQueue.maxConcurrentOperationCount = PWNMaxConcurrentOperationCountForReachabilityStatus([PWNReachability sharedInstance].currentReachabilityStatus);
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:PWNReachabilityDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)load {
    [[PWNReachability sharedInstance] startMonitoring];
}


#pragma mark - Notification 

- (void)networkReachabilityDidChange:(NSNotification *)notification {
    self.sessionManager.operationQueue.maxConcurrentOperationCount = PWNMaxConcurrentOperationCountForReachabilityStatus([PWNReachability sharedInstance].currentReachabilityStatus);
}

- (void)sendRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completionHandler {
    if (request.requestType == PWNRequestNormal) {
        [self m_dataTaskWithRequest:request completionHandler:completionHandler];
    } else if (request.requestType == PWNRequestUpload) {
        [self m_uploadTaskWithRequest:request completionHandler:completionHandler];
    } else if (request.requestType == PWNRequestDownload) {
        [self m_downloadTaskWithRequest:request completionHandler:completionHandler];
    } else {
        PWNAssert(NO, @"Unknown request type.");
    }
}

- (void)cancelRequest:(PWNRequest *)request {
    [request.task cancel];
}

#pragma mark - Private method

- (NSString *)m_httpMethodForType:(PWNHTTPMethodType)type {
    switch (type) {
        case PWNHTTPMethodGET: return @"GET";
        case PWNHTTPMethodPOST: return @"POST";
        case PWNHTTPMethodHEAD: return @"HEAD";
        case PWNHTTPMethodDELETE: return @"DELETE";
        case PWNHTTPMethodPUT: return @"PUT";
        case PWNHTTPMethodPATCH: return @"PATCH";
    }
    return nil;
}

- (void)m_processURLRequest:(NSMutableURLRequest *)urlRequest withPWNRequest:(PWNRequest *)request {
    if (request.entireHeaders.count > 0) {
        [request.entireHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *field, NSString *value, BOOL *stop) {
            [urlRequest setValue:value forHTTPHeaderField:field];
        }];
    }
    urlRequest.timeoutInterval = request.timeoutInterval;
}

- (void)m_processResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error request:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (responseObject) {
        userInfo[PWNetworkRequestDidCompleteResponseDataKey] = responseObject;
    }
    
    if (error) {
        userInfo[PWNetworkRequestDidCompleteErrorKey] = error;
        if (completion) {
            completion(responseObject, error);
        }
    } else {
        // TODO 处理序列化的地方需要重新创建一个线程 url_session_manager_processing_queue
//        dispatch_async(url_session_manager_processing_queue(), ^{
        
//        });
        
        NSError *serializationError = nil;
        AFHTTPResponseSerializer *responseSerializer = [self m_responseSerializerForRequest:request];
        responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&serializationError];
        
        if (serializationError) {
            userInfo[PWNetworkRequestDidCompleteErrorKey] = serializationError;
        }
        
        if (responseObject) {
            userInfo[PWNetworkRequestDidCompleteSerializedResponseKey] = responseObject;
        }
        if (completion) {
            if (serializationError) {
                completion(nil, serializationError);
            } else {
                completion(responseObject, nil);
            }
        }
    }
    [self m_postRequestDidCompleteNotification:request withUserInfo:userInfo];
}

- (void)m_setIdentifierForRequest:(PWNRequest *)request urlSessiontask:(NSURLSessionTask *)task sessionManager:(AFHTTPSessionManager *)manager {
    NSString *identifier = nil;
    if ([manager isEqual:self.sessionManager]) {
        identifier = [NSString stringWithFormat:@"+%@", @(task.taskIdentifier)];
    }
    request.identifier = identifier;
}

- (void)m_bindTask:(NSURLSessionTask *)task toRequest:(PWNRequest *)request {
    request.task = task;
}

- (AFHTTPRequestSerializer *)m_requestSerializerForRequest:(PWNRequest *)request {
    switch (request.requestSerializerType) {
        case PWNRequestSerializerRaw: return self.afHTTPRequestSerializer;
        case PWNRequestSerializerJSON: return self.afJSONRequestSerializer;
        case PWNRequestSerializerPlist: return self.afPListRequestSerializer;
    }
    PWNAssert(NO, @"Unknown request serializer type.");
    return nil;
}

- (AFHTTPResponseSerializer *)m_responseSerializerForRequest:(PWNRequest *)request {
    switch (request.responseSerializerType) {
        case PWNResponseSerializerRaw: return self.afHTTPResponseSerializer;
        case PWNResponseSerializerJSON: return self.afJSONResponseSerializer;
        case PWNResponseSerializerXML: return self.afXMLResponseSerializer;
        case PWNResponseSerializerPlist: return self.afPListResponseSerializer;
    }
    PWNAssert(NO, @"Unknown response serializer type.");
    return nil;
}

- (void)m_postRequestDidStartNotification:(PWNRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PWNetworkRequestDidStartNotification object:request];
    });
}

- (void)m_postRequestDidCompleteNotification:(PWNRequest *)request withUserInfo:(NSDictionary *)userInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PWNetworkRequestDidCompleteNotification object:request userInfo:userInfo];
    });
}

- (void)m_dataTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion {
    
    NSString *httpMethod = [self m_httpMethodForType:request.httpMethodType];
    PWNAssert(httpMethod.length > 0, @"Unknown HTTP method.");
    
    NSError *serializationError = nil;
    AFHTTPRequestSerializer *requestSerializer = [self m_requestSerializerForRequest:request];
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:httpMethod
                                                                 URLString:request.url
                                                                parameters:request.entireParameters
                                                                     error:&serializationError];
    if (serializationError) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
        }
        return;
    }
    
    [self m_processURLRequest:urlRequest withPWNRequest:request];
    
    NSURLSessionDataTask *dataTask = nil;
    __weak __typeof__(self) weakSelf = self;
    dataTask = [self.sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf m_processResponse:response responseObject:responseObject error:error request:request completionHandler:completion];
    }];
    
    [self m_setIdentifierForRequest:request urlSessiontask:dataTask sessionManager:self.sessionManager];
    
    [self m_bindTask:dataTask toRequest:request];
    
    [dataTask resume];
    
    [self m_postRequestDidStartNotification:request];
}

- (void)m_downloadTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.url]];
    [self m_processURLRequest:urlRequest withPWNRequest:request];
    
    NSString *downloadFileSavePath;
    
    NSString *cachesDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachesFileName = PWNStringFromDate([NSDate date]);
    NSString *cachesFileSavePath = [cachesDirectoryPath stringByAppendingPathComponent:cachesFileName];

    if (request.downloadFileDirectory) {
        BOOL isDir;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:request.downloadFileDirectory isDirectory:&isDir];
        if (isDir) {
            NSError *error;
            if (!exist) {
                [[NSFileManager defaultManager] createDirectoryAtPath:request.downloadFileDirectory withIntermediateDirectories:YES attributes:nil error:&error];
            }
            if (error || !request.downloadFileName) {
                downloadFileSavePath = cachesFileSavePath;
            } else {
                downloadFileSavePath = [request.downloadFileDirectory stringByAppendingPathComponent:request.downloadFileName];
            }
        }
    } else {
        if (request.downloadFileName) {
            downloadFileSavePath = [cachesDirectoryPath stringByAppendingPathComponent:request.downloadFileName];
        } else {
            downloadFileSavePath = cachesFileSavePath;
        }
    }
    
    request.downloadFilePath = downloadFileSavePath;
    
    NSURLSessionDownloadTask *downloadTask = nil;
    __weak __typeof__(self) weakSelf = self;
    downloadTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:request.progressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:downloadFileSavePath isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (completion) {
            completion(filePath, error);
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        if (error) {
            userInfo[PWNetworkRequestDidCompleteErrorKey] = error;
        }
        [strongSelf m_postRequestDidCompleteNotification:request withUserInfo:userInfo];
    }];
    
    [self m_setIdentifierForRequest:request urlSessiontask:downloadTask sessionManager:self.sessionManager];
    
    [self m_bindTask:downloadTask toRequest:request];
    
    [downloadTask resume];
    
    [self m_postRequestDidStartNotification:request];
}

- (void)m_uploadTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion {
    
    __block NSError *serializationError = nil;
    AFHTTPRequestSerializer *requestSerializer = [self m_requestSerializerForRequest:request];
    NSMutableURLRequest *urlRequest = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:request.url parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (PWNUploadFormData *data in request.uploadFormDatas) {
            if (data.fileData) {
                if (data.fileName && data.mimeType) {
                    [formData appendPartWithFileData:data.fileData name:data.name fileName:data.fileName mimeType:data.mimeType];
                } else {
                    [formData appendPartWithFormData:data.fileData name:data.name];
                }
            } else if (data.fileURL) {
                NSError *fileError;
                if (data.fileName && data.mimeType) {
                    [formData appendPartWithFileURL:data.fileURL name:data.name fileName:data.fileName mimeType:data.mimeType error:&fileError];
                } else {
                    [formData appendPartWithFileURL:data.fileURL name:data.name error:&fileError];
                }
                if (fileError) {
                    serializationError = fileError;
                    break;
                }
            }
        }
    } error:&serializationError];
    
    if (serializationError) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
        }
        return;
    }
    
    [self m_processURLRequest:urlRequest withPWNRequest:request];
    
    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof__(self) weakSelf = self;
    uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:urlRequest progress:request.progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf m_processResponse:response responseObject:responseObject error:error request:request completionHandler:completion];
    }];

    [self m_setIdentifierForRequest:request urlSessiontask:uploadTask sessionManager:self.sessionManager];
    
    [self m_bindTask:uploadTask toRequest:request];
    
    [uploadTask resume];
    
    [self m_postRequestDidStartNotification:request];
}

@end
