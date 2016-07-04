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

- (MSURLSSessionTask *)sendRequestForURL:(NSURL *)aURL
                                   httpMethod:(NSString *)httpMethod
                           responseModelClass:(Class)responseModelClass
                                   parameters:(NSDictionary *)parameters
                                      success:(BlockHTTPRequestSuccess)success
                                      failure:(BlockHTTPRequestFailure)failure
{
    
    NSError *reError = nil;
    NSURLRequest *request = [self.requestSerializer requestWithMethod:httpMethod URLString:[aURL absoluteString] parameters:parameters error:&reError];
    
    NSLog(@"reError %@",reError.userInfo);
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/json",nil];
    NSAssert(reError == nil, @"get request error:Url = %@ Method = %@ param = %@", aURL, httpMethod, parameters);
    
    __block MSURLSSessionTask * task = nil;
    
   task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
       if (_isLoggingEnabled) {
           NSLog(@"url=== %@ parameters===%@ responseObject== %@",response.URL,parameters,responseObject);
       }
       
       if (error) {
           if(failure) {
               failure(task, error);
           }
       }else{
           
           NSError *convertError = nil;
           //转换模型
           NSObject *responseModel = [LMSNetworking modelFromResponseDictionary:[LMSNetworking dictionaryFromResponseData:responseObject] withModelClass:responseModelClass error:&convertError];
           
           if (convertError == nil && success && responseModelClass != nil) {
               success(task, responseModel);
           }else{
               failure(task, convertError);
           }

       }

       
    }];
    [task resume];
    return task;
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
        aModel = (NSObject *)[ModelClass yy_modelWithDictionary:dictionary];
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

@end
