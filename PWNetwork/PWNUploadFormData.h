//
//  PWNUploadFormData.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 10/02/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWNUploadFormData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy, nullable) NSString *fileName;

@property (nonatomic, copy, nullable) NSString *mimeType;

@property (nonatomic, copy, nullable) NSData *fileData;

@property (nonatomic, copy, nullable) NSURL *fileURL;

@end

NS_ASSUME_NONNULL_END

