//
//  PWNReachability.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 08/02/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWNReachabilityStatus) {
    PWNReachabilityStatusUnknown          = -1,
    PWNReachabilityStatusNotReachable     = 0,
    PWNReachabilityStatusReachableViaWWAN = 1,
    PWNReachabilityStatusReachableViaWiFi = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface PWNReachability : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

- (PWNReachabilityStatus)currentReachabilityStatus;

- (BOOL)isReachable;

- (BOOL)isReachableViaWWAN;

- (BOOL)isReachableViaWiFi;

@end

/// 网络状态发生变化的通知，object传的是PWNReachability对象
FOUNDATION_EXPORT NSString * const PWNReachabilityDidChangeNotification;

FOUNDATION_EXPORT NSString * PWNStringFromNetworkReachabilityStatus(PWNReachabilityStatus status);

NS_ASSUME_NONNULL_END
