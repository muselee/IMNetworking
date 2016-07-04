//
//  IMRequest.m
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "LMSRequest.h"
#import "LMSServiceModel.h"
#import "LMSServiceXMLData.h"
@interface LMSRequest(){
    LMSServiceModel* _serviceMethod;
    NSArray* _parameterValues;
    callBackResponse _successCallback;
    callBackResponse _failCallback;
    
    NSArray * _commonValues;
}
@end
@implementation LMSRequest

-(void) send:(callBackResponse) successCallback {
    _successCallback = successCallback;
    [self send];
}
-(void) setHeaderValue:(NSString*) value forName:(NSString*) name{
    [self.requestSerializer setValue:value forHTTPHeaderField:name];
}
-(void) send:(callBackResponse) successCallback failCallback:(callBackResponse)failCallback {
    
    _successCallback = successCallback;
    _failCallback = failCallback;
    [self send];
}

-(void) send {
    //获取打印标志
    self.isLoggingEnabled = _serviceMethod.isLoggingEnabled;
    //获取完整URL
    NSURL * url = [NSURL URLWithString:_serviceMethod.address];
    //获取请求方法
    NSString * method = [_serviceMethod.method uppercaseString];
    //拼接参数
    NSMutableDictionary * parameter = [_serviceMethod assembleParametersWithValues:_parameterValues];
   
    //获取公共参数
    NSMutableDictionary * commonParameter = [_serviceMethod assembleCommonParametersWithValues:_commonValues];
    if (commonParameter) {
        [parameter addEntriesFromDictionary:commonParameter];
        if (parameter==nil) {
            parameter = commonParameter;
        }
    }
    //设置超时
    self.requestSerializer.timeoutInterval = _serviceMethod.timeout;
    
    [self sendRequestForURL:url httpMethod:method responseModelClass:_serviceMethod.returnType parameters:parameter success:^(MSURLSSessionTask *task, id responseObject) {
        if (_successCallback) {
            _successCallback(responseObject);
        }
    } failure:^(MSURLSSessionTask *task, NSError *error) {
        if (_failCallback) {
            LMSServiceError* serviceError = nil;
            if (error != nil) {
                if (error.code ==9999) {
                    //数模转换错误
                    serviceError = [[LMSServiceError alloc] init];
                    serviceError.message = kNetworkAPIErrorModelParse;
                    serviceError.errorType = LMSServiceErrorTypeParsing;
                }else {
                    //网络错误 超时 服务器地址错误 等
                    serviceError = [[LMSServiceError alloc] init];
                    serviceError.message = [_serviceMethod messageForError:error];
                    serviceError.errorType = LMSServiceErrorTypeNetwork;
                }
                
            }
            else {
                // http 请求错误
                serviceError = [[LMSServiceError alloc] init];
                serviceError.errorType = LMSServiceErrorTypeHttp;
            }
            
            _failCallback(serviceError);
        }

    }];
}
+(instancetype) create:(NSString*)serviceMethodName parameterValues:(NSArray*) parameterValues {
    
    LMSRequest* request = [[LMSRequest alloc] init];
    request->_serviceMethod = [LMSServiceXMLData methodWithName:serviceMethodName];
    request->_parameterValues = parameterValues;
    return request;
}
- (void)addCommonParameterValues:(NSArray *)parameterValues{
    _commonValues =[ NSArray arrayWithArray:parameterValues];
}
@end
