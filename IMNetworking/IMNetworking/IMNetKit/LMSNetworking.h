//
//  IMNetworking.h
//  MGJRequestManagerDemo
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 bestdo. All rights reserved.
//

#import "AFNetworking.h"
#import "MJExtension.h"
#define kModelNetworkDefaultArrayKey    @"kObjectDefaultArrayKey"
#define kNetworkAPIErrorModelParse      @"Model解析错误[数据类型不匹配]"
typedef NS_ENUM(NSUInteger,LMSNetworkAPIErrorCode) {
    // Model解析错误
    LMSNetworkAPIErrorCodeModelParse = 9999
    
};
// 成功和失败块
typedef void (^BlockHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BlockHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface LMSNetworking : AFHTTPRequestOperationManager


@property (nonatomic,assign) BOOL isLoggingEnabled;

//基础类
- (AFHTTPRequestOperation *)sendRequestForURL:(NSURL *)fullURL
                                   httpMethod:(NSString *)httpMethod
                           responseModelClass:(Class)responseModelClass
                               withParameters:(NSDictionary *)parameters
                                      success:(BlockHTTPRequestSuccess)success
                                      failure:(BlockHTTPRequestFailure)failure;

@end
