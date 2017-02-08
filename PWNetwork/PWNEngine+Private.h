//
//  PWNEngineInternal.h
//  PWNetworkDemo
//
//  Created by Huang Wei on 22/01/2017.
//  Copyright © 2017 Parallel World. All rights reserved.
//

#import "PWNEngine.h"
#import "PWNDefines.h"
#import "AFNetworking.h"

@class PWNRequest;

@interface PWNEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) AFHTTPRequestSerializer *afHTTPRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *afJSONRequestSerializer;
@property (nonatomic, strong) AFPropertyListRequestSerializer *afPListRequestSerializer;

@property (nonatomic, strong) AFHTTPResponseSerializer *afHTTPResponseSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer *afJSONResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *afXMLResponseSerializer;
@property (nonatomic, strong) AFPropertyListResponseSerializer *afPListResponseSerializer;


- (void)m_dataTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion;
- (void)m_uploadTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion;
- (void)m_downloadTaskWithRequest:(PWNRequest *)request completionHandler:(PWNCompletionHandler)completion;

/// 根据httpMethodType返回对应的字符串
- (NSString *)m_httpMethodForType:(PWNHTTPMethodType)type;

/// 根据PWNRequest来处理请求的urlRequest
- (void)m_processURLRequest:(NSMutableURLRequest *)urlRequest withPWNRequest:(PWNRequest *)request;

/// 处理响应结果
- (void)m_processResponse:(NSURLResponse *)response
           responseObject:(id)object
                    error:(NSError *)error
                  request:(PWNRequest *)request
        completionHandler:(PWNCompletionHandler)completion;

/// 设置request的identifier
- (void)m_setIdentifierForRequest:(PWNRequest *)request
                   urlSessiontask:(NSURLSessionTask *)task
                   sessionManager:(AFHTTPSessionManager *)manager;

/// 建立task和request的对应关系
- (void)m_bindTask:(NSURLSessionDataTask *)task toRequest:(PWNRequest *)request;



@end
