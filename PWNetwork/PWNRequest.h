//
//  PWNRequest.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWNDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWNRequest : NSObject

@property (nonatomic, copy, nullable) NSString *host;

@property (nonatomic, copy, nullable) NSString *api;

@property (nonatomic, copy, nullable) NSString *url;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *parameters;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *headers;

@property (nonatomic, assign) BOOL useGeneralHost;

@property (nonatomic, assign) BOOL useGeneralParameters;

@property (nonatomic, assign) BOOL useGeneralHeaders;

@property (nonatomic, assign) PWNHTTPMethodType httpMethodType;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end

NS_ASSUME_NONNULL_END
