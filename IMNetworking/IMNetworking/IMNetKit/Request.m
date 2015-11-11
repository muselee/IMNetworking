//
//  IMRequest.m
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "Request.h"
#import "ServiceModel.h"
#import "ServiceXMLData.h"
@interface Request(){
    ServiceModel* _serviceMethod;
    NSArray* _parameterValues;
    callBackResponse _successCallback;
    callBackResponse _failCallback;
}
@end
@implementation Request

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
    NSDictionary * parameter = [_serviceMethod assembleParametersWithValues:_parameterValues];
    //设置超时
    self.requestSerializer.timeoutInterval = _serviceMethod.timeout;
    [self sendRequestForURL:url httpMethod:method responseModelClass:_serviceMethod.returnType withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_successCallback) {
             _successCallback(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_failCallback) {
            ServiceError* serviceError = nil;
            if (error != nil) {
                if (error.code ==9999) {
                    //数模转换错误
                    serviceError = [[ServiceError alloc] init];
                    serviceError.message = kNetworkAPIErrorModelParse;
                    serviceError.errorType = ServiceErrorTypeParsing;
                }else {
                    //网络错误 超时 服务器地址错误 等
                    serviceError = [[ServiceError alloc] init];
                    serviceError.message = [_serviceMethod messageForError:error];
                    serviceError.errorType = ServiceErrorTypeNetwork;
                }
               
            }
            else {
                // http 请求错误
                serviceError = [[ServiceError alloc] init];
                serviceError.httpCode = operation.response.statusCode;
                serviceError.message = operation.responseString;
                serviceError.errorType = ServiceErrorTypeHttp;
            }

            _failCallback(serviceError);
        }
    }];
}
+(instancetype) create:(NSString*)serviceMethodName parameterValues:(NSArray*) parameterValues {
    
    Request* request = [[Request alloc] init];
    request->_serviceMethod = [ServiceXMLData methodWithName:serviceMethodName];
    request->_parameterValues = parameterValues;
    return request;
}
@end
