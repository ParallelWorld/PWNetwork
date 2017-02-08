//
//  PWNReachability.m
//  PWNetworkDemo
//
//  Created by Huang Wei on 08/02/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNReachability.h"

#import "AFNetworking.h"

NSString * const PWNReachabilityDidChangeNotification = @"PWNReachabilityDidChangeNotification";

@implementation PWNReachability

+ (instancetype)sharedInstance {
    static PWNReachability *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startMonitoring {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)stopMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PWNReachabilityStatus)currentReachabilityStatus {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

- (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (BOOL)isReachableViaWiFi {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

- (BOOL)isReachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

#pragma mark - Private method

- (void)networkReachabilityDidChange:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PWNReachabilityDidChangeNotification object:self];
    });
}

@end
