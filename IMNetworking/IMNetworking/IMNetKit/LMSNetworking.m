//
//  IMNetworking.m
//  MGJRequestManagerDemo
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 bestdo. All rights reserved.
//

#import "LMSNetworking.h"
NSString *const kNetworkDataParseErrorDomain = @"Networking.PARSE.ERROR";

@interface LMSNetworking()
@end
@implementation LMSNetworking

#pragma mark - 基础Http请求

- (AFHTTPRequestOperation *)sendRequestForURL:(NSURL *)aURL httpMethod:(NSString *)httpMethod responseModelClass:(Class)responseModelClass withParameters:(NSDictionary *)parameters success:(BlockHTTPRequestSuccess)success failure:(BlockHTTPRequestFailure)failure
{
    //Add public HTTP params
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //添加公共参数
    //相同key会覆盖公共参数
    [dictionary addEntriesFromDictionary:parameters];
    
    NSError *reError = nil;
    NSURLRequest *request = [self.requestSerializer requestWithMethod:httpMethod URLString:[aURL absoluteString] parameters:dictionary error:&reError];
    NSAssert(reError == nil, @"get request error:Url = %@ Method = %@ param = %@", aURL, httpMethod, parameters);
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_isLoggingEnabled) {
            NSLog(@"responseObject %@",responseObject);
        }
        NSError *error = nil;
        //转换模型
        NSObject *responseModel = [LMSNetworking modelFromResponseDictionary:[LMSNetworking dictionaryFromResponseData:responseObject] withModelClass:responseModelClass error:&error];
        
        if (error == nil && success && responseModelClass != nil) {
            success(operation, responseModel);
        }else{
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    if (operation != nil) {
        [self.operationQueue addOperation:operation];
    }else{
        NSLog(@"error operation = nil");
    }
    
    return operation;
}
#pragma mark - Model Network Client Support Service data

+ (BOOL)isClassTypeSupport:(id)checkData
{
    if ([checkData isKindOfClass:[NSData class]] ||
        [checkData isKindOfClass:[NSDictionary class]] ||
        [checkData isKindOfClass:[NSArray class]]) {
        return YES;
    }
    
    return NO;
}
#pragma mark - Model Network Client Tools

+ (NSDictionary *)dictionaryFromResponseData:(id)responseData {
    
    if ([LMSNetworking isClassTypeSupport:responseData] == NO) {
        return nil;
    }
    
    if ([responseData isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    }
    
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)responseData;
    }
    
    if ([responseData isKindOfClass:[NSArray class]]) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [mDic setObject:responseData forKey:kModelNetworkDefaultArrayKey];
        return mDic;
    }
    
    return nil;
}
+ (NSObject *)modelFromResponseDictionary:(NSDictionary *)dictionary
                                         withModelClass:(Class)ModelClass
                                                      error:(NSError **)error {
    
    NSObject *aModel = nil;
    
    @try
    {
        //如何需要特殊处理服务器返回的数据结构，在此处处理
        aModel = (NSObject *)[ModelClass objectWithKeyValues:dictionary error:error];
    }
    @catch (NSException *exception) {
        *error = [NSError errorWithDomain:kNetworkDataParseErrorDomain
                                     code:LMSNetworkAPIErrorCodeModelParse
                                 userInfo:@{
                                            NSLocalizedDescriptionKey:kNetworkAPIErrorModelParse
                                            }];
    }
    @finally {
    }
    
    return aModel;
}
- (void)addresponseSerializerContentTypes:(NSString *)contentType
{
    NSMutableSet *nSet = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
    [nSet addObject:contentType];
    [self.responseSerializer setAcceptableContentTypes:nSet];
}
@end
