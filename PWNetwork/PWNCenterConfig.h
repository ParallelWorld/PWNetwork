//
//  PWNCenterConfig.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWNCenterConfig : NSObject

@property (nonatomic, copy, nullable) NSString *generalHost;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *generalParameters;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

@end

NS_ASSUME_NONNULL_END
