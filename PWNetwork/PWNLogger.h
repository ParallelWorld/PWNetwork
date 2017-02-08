//
//  PWNLogger.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 07/02/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWNHTTPRequestLoggerLevel) {
    PWNLoggerLevelOff,
    PWNLoggerLevelDebug,
    PWNLoggerLevelInfo,
    PWNLoggerLevelWarn,
    PWNLoggerLevelError,
    PWNLoggerLevelFatal = PWNLoggerLevelOff,
};

NS_ASSUME_NONNULL_BEGIN

@interface PWNLogger : NSObject

@property (nonatomic, assign) PWNHTTPRequestLoggerLevel level;

@property (nonatomic, strong, nullable) NSPredicate *filterPredicate;

+ (instancetype)sharedLogger;

- (void)startLogging;

- (void)stopLogging;

@end

NS_ASSUME_NONNULL_END
