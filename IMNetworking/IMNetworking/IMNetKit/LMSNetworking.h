//
//  IMNetworking.h
//  MGJRequestManagerDemo
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 bestdo. All rights reserved.
//

#import "AFNetworking.h"
#import <YYModel.h>
#define kModelNetworkDefaultArrayKey    @"kObjectDefaultArrayKey"
#define kNetworkAPIErrorModelParse      @"Model解析错误[数据类型不匹配]"
typedef NS_ENUM(NSUInteger,LMSNetworkAPIErrorCode) {
    // Model解析错误
    LMSNetworkAPIErrorCodeModelParse = 9999
    
};

typedef NSURLSessionTask MSURLSSessionTask;
// 成功和失败块
typedef void (^BlockHTTPRequestSuccess)(MSURLSSessionTask *task, id responseObject);
typedef void (^BlockHTTPRequestFailure)(MSURLSSessionTask *task, NSError *error);

@interface LMSNetworking : AFHTTPSessionManager


@property (nonatomic,assign) BOOL isLoggingEnabled;

//基础类
- (MSURLSSessionTask *)sendRequestForURL:(NSURL *)fullURL
                              httpMethod:(NSString *)httpMethod
                      responseModelClass:(Class)responseModelClass
                              parameters:(NSDictionary *)parameters
                                 success:(BlockHTTPRequestSuccess)success
                                 failure:(BlockHTTPRequestFailure)failure;

@end
