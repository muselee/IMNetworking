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
typedef NS_ENUM(NSUInteger,NetworkAPIErrorCode) {
    // Model解析错误
    NetworkAPIErrorCodeModelParse = 9999
    
};
// 成功和失败块
typedef void (^BlockHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BlockHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface Networking : AFHTTPRequestOperationManager


@property (nonatomic,assign)BOOL isLoggingEnabled;

//基础类
- (AFHTTPRequestOperation *)sendRequestForURL:(NSURL *)fullURL
                                   httpMethod:(NSString *)httpMethod
                           responseModelClass:(Class)responseModelClass
                               withParameters:(NSDictionary *)parameters
                                      success:(BlockHTTPRequestSuccess)success
                                      failure:(BlockHTTPRequestFailure)failure;
#pragma mark - Override Method

/**
 *  Override此函数，这样你所有的请求都会带有你返回的参数,LIKE - apiVersion,timestamp
 *
 *  @return  返回Dic，会加入到请求的参数中去
 */
- (NSDictionary *)commonRequestParam;

/**
 *  Override此函数
 *  当你需要统一修改服务器返回的数据结构时，可以重载该方法,在把Dic映射到Model前修改Dic，给予更好的数据结构
 *  保证返回的model的结构一致性
 *  该方法需求来源于 服务器返回字段架构一致性 From Baidu Nuomi
 *
 *  @param netDic   原始网络数据转化成的Dic
 *
 *  @return  处理过的Dic
 */
+ (NSDictionary *)willParseDicToModel:(NSDictionary *)netDic;

@end
