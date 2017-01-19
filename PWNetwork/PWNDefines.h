//
//  PWNDefines.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 19/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#ifndef PWNDefines_h
#define PWNDefines_h

@class PWNRequest;

NS_ASSUME_NONNULL_BEGIN

#define PWNAssert( condition, ... ) NSCAssert( (condition) , ##__VA_ARGS__)
#define PWNParameterAssert( condition ) PWNAssert( (condition) , @"Invalid parameter not satisfying: %@", @#condition)
#define PWNAssertMainThread() PWNAssert( ([NSThread isMainThread] == YES), @"Must be on the main thread")



#define PWN_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

typedef NS_ENUM(NSUInteger, PWNHTTPMethodType) {
    PWNHTTPMethodGET = 0,
    PWNHTTPMethodPOST,
};

static inline NSString *HTTP_METHOD_NAME_FOR_TYPE(PWNHTTPMethodType type) {
    NSArray *names = @[@"GET", @"POST"];
    return names[type];
}

typedef void (^PWNRequestConfigBlock)(PWNRequest *request);

#pragma mark - Callback blocks

typedef void (^PWNProgressBlock)(NSProgress *progress);
typedef void (^PWNSuccessBlock)(id _Nullable responseObject);
typedef void (^PWNFailureBlock)(NSError * _Nullable error);
typedef void (^PWNCompletionBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^PWNCancelBlock)(PWNRequest * _Nullable request);


NS_ASSUME_NONNULL_END

#endif /* PWNDefines_h */
