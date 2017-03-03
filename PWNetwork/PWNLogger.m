//
//  PWNLogger.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 07/02/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNLogger.h"
#import "AFNetworking.h"
#import "PWNEngine.h"
#import "PWNRequest.h"
#import "PWNRequestInternal.h"

#import <objc/runtime.h>

static NSURLRequest * PWNetworkRequestFromNotification(NSNotification *notification) {
    PWNRequest *request = [notification object];
    return request.task.originalRequest;
}

static NSError * PWNetworkErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;
    PWNRequest *request = [notification object];
    NSDictionary *userInfo = [notification userInfo];
    error = request.task.error;
    if (!error) {
        error = userInfo[PWNetworkRequestDidCompleteErrorKey];
    }
    return error;
}

static NSDictionary * PWNetworkDictionaryFromURLQuery(NSString *query) {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSArray *queryComponents = [query componentsSeparatedByString:@"&"];
    for (NSString *kvPair in queryComponents) {
        NSArray *kvComponents = [kvPair componentsSeparatedByString:@"="];
        NSString *key = [kvComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [kvComponents.lastObject stringByRemovingPercentEncoding];
        if (value) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}

@implementation PWNLogger

+ (instancetype)sharedLogger {
    static PWNLogger *sharedLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [[self alloc] init];
    });
    return sharedLogger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.level = PWNLoggerLevelInfo;
    }
    return self;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)startLogging {
    [self stopLogging];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:PWNetworkRequestDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidComplete:) name:PWNetworkRequestDidCompleteNotification object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static void * PWNetworkRequestStartDate = &PWNetworkRequestStartDate;

- (void)networkRequestDidStart:(NSNotification *)notification {
    NSURLRequest *request = PWNetworkRequestFromNotification(notification);
    PWNRequest *pwnRequest = notification.object;
    
    if (!request) {
        return;
    }
    
    if (request && self.filterPredicate && [self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    objc_setAssociatedObject(pwnRequest, PWNetworkRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    // 打印
    NSMutableString *logString = @"".mutableCopy;
    [logString appendString:@"\n\n"];
    [logString appendString:@"==========================================================================\n"];
    [logString appendString:@"                                REQUEST\n"];
    [logString appendString:@"==========================================================================\n"];

    switch (self.level) {
        case PWNLoggerLevelDebug: {
            [logString appendFormat:@"HTTP Encoded URL  %@\n", request.URL.absoluteString];
            [logString appendFormat:@"HTTP Decoded URL  %@\n", request.URL.absoluteString.stringByRemovingPercentEncoding];
            [logString appendFormat:@"HTTP Scheme       %@\n", request.URL.scheme];
            [logString appendFormat:@"HTTP Port         %@\n", request.URL.port];
            [logString appendFormat:@"HTTP Method       %@\n", request.HTTPMethod];
            [logString appendFormat:@"HTTP Host         %@\n", request.URL.host];
            [logString appendFormat:@"HTTP Api          %@\n", request.URL.path];
            [logString appendFormat:@"HTTP Request Type %@\n", PWNStringForRequestType(pwnRequest.requestType)];
            [logString appendFormat:@"HTTP Headers      %@\n", request.allHTTPHeaderFields];
            [logString appendFormat:@"HTTP Parameters   %@\n", PWNetworkDictionaryFromURLQuery(request.URL.query)];
            [logString appendFormat:@"HTTP Body         %@\n", body];
            break;
        }
        case PWNLoggerLevelInfo: {
            [logString appendFormat:@"HTTP Method       %@\n", request.HTTPMethod];
            [logString appendFormat:@"HTTP URL          %@\n", request.URL.absoluteString];
            break;
        }
        default:
            break;
    }
    
    [logString appendString:@"==========================================================================\n"];
    [logString appendString:@"==========================================================================\n"];
    [logString appendString:@"\n\n"];

    NSLog(@"%@", logString);
}

- (void)networkRequestDidComplete:(NSNotification *)notification {
    PWNRequest *pwnRequest = notification.object;
    NSURLRequest *request = PWNetworkRequestFromNotification(notification);
    NSURLResponse *response = pwnRequest.task.response;
    NSError *error = PWNetworkErrorFromNotification(notification);
    
    if (!request && !response) {
        return;
    }
    
    if (request && self.filterPredicate && [self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    
    id responseObject = nil;
    if (notification.userInfo) {
        responseObject = notification.userInfo[PWNetworkRequestDidCompleteSerializedResponseKey];
    }
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(pwnRequest, PWNetworkRequestStartDate)];
    
    
    // 打印
    NSMutableString *logString = @"".mutableCopy;
    [logString appendString:@"\n\n"];
    [logString appendString:@"**************************************************************************\n"];
    [logString appendString:@"                               RESPONSE\n"];
    [logString appendString:@"**************************************************************************\n"];

    if (error) {
        switch (self.level) {
            case PWNLoggerLevelDebug:
            case PWNLoggerLevelInfo:
            case PWNLoggerLevelWarn:
            case PWNLoggerLevelError: {
                [logString appendFormat:@"[Error]\n"];
                [logString appendFormat:@"HTTP Method       %@\n", request.HTTPMethod];
                [logString appendFormat:@"HTTP Encoded URL  %@\n", request.URL.absoluteString];
                [logString appendFormat:@"HTTP Decoded URL  %@\n", request.URL.absoluteString.stringByRemovingPercentEncoding];
                [logString appendFormat:@"HTTP StatusCode   %@\n", @(responseStatusCode)];
                [logString appendFormat:@"ElapsedTime       %.04f s\n", elapsedTime];
                [logString appendFormat:@"Error             %@\n", error];
                break;
            }
                
            default:
                break;
        }
    } else {
        switch (self.level) {
            case PWNLoggerLevelDebug: {
                [logString appendFormat:@"HTTP StatusCode   %@\n", @(responseStatusCode)];
                [logString appendFormat:@"HTTP Method       %@\n", request.HTTPMethod];
                [logString appendFormat:@"HTTP Request Type %@\n", PWNStringForRequestType(pwnRequest.requestType)];
                [logString appendFormat:@"HTTP Encoded URL  %@\n", request.URL.absoluteString];
                [logString appendFormat:@"HTTP Decoded URL  %@\n", request.URL.absoluteString.stringByRemovingPercentEncoding];
                [logString appendFormat:@"HTTP Headers      %@\n", responseHeaderFields];
                [logString appendFormat:@"ElapsedTime       %.04f s\n", elapsedTime];

                if (pwnRequest.requestType == PWNRequestNormal) {
                    [logString appendFormat:@"HTTP Response     %@\n", responseObject];
                } else if (pwnRequest.requestType == PWNRequestDownload){
                    [logString appendFormat:@"DownloadFilePath  %@\n", pwnRequest.downloadFilePath];
                } else if (pwnRequest.requestType == PWNRequestUpload) {
                    [logString appendFormat:@"Upload Response   %@\n", responseObject];
                }
                break;
            }
            case PWNLoggerLevelInfo: {
                [logString appendFormat:@"HTTP StatusCode   %@\n", @(responseStatusCode)];
                [logString appendFormat:@"HTTP Method       %@\n", request.HTTPMethod];
                [logString appendFormat:@"HTTP URL          %@\n", request.URL.absoluteString];
                [logString appendFormat:@"ElapsedTime       %.04f s\n", elapsedTime];
                break;
            }
            default:
                break;
        }
    }
    
    [logString appendString:@"**************************************************************************\n"];
    [logString appendString:@"**************************************************************************\n"];
    [logString appendString:@"\n\n"];

    NSLog(@"%@", logString);
}

@end
