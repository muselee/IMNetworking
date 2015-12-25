//
//  ServiceMetadata.m
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "LMSServiceXMLData.h"
#import "RXMLElement.h"
#import "LMSServiceModel.h"

static NSMutableDictionary* methods;
static NSString * service_config = @"Service_Config.xml";
@implementation LMSServiceXMLData

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LMSServiceXMLData loadServiceMethods];
    });
}

+ (void)loadServiceMethods {
    
    RXMLElement *root = [RXMLElement elementFromXMLFile:service_config];
  
    
    __block NSString* httpMethod;
    __block NSInteger timeout;
    __block BOOL isLoggingEnabled;
    __block NSString* timeoutMessage;
    __block NSString* failbackMessage;
    __block NSString* message;
    __block BOOL showWaitBox;
    __block NSString * commonParameters;
    
    //获取默认设置
    [root iterate:@"Defaults" usingBlock: ^(RXMLElement *e) {
        
        httpMethod = [e attribute:@"Method"] ? [e attribute:@"Method"] : @"GET";
        timeout = [e attribute:@"Timeout"] ? [[e attribute:@"Timeout"] integerValue] :60;
        
        message = [e attribute:@"Message"] ? [e attribute:@"Message"] : @"";
         showWaitBox = [e attribute:@"ShowWaitBox"] ? [[[e attribute:@"ShowWaitBox"] uppercaseString]isEqualToString:@"YES"] : YES;
        isLoggingEnabled = [e attribute:@"IsLoggingEnabled"] ? [[[e attribute:@"IsLoggingEnabled"] uppercaseString] isEqualToString:@"YES"] : NO;
        timeoutMessage = [e attribute:@"TimeoutMessage"] ? [e attribute:@"TimeoutMessage"] : nil;
        failbackMessage = [e attribute:@"FailbackMessage"] ? [e attribute:@"FailbackMessage"] : nil;
        
        commonParameters= [e attribute:@"CommonParameters"]?:nil;
        
    }];

    
    methods = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* urls = [[NSMutableDictionary alloc] init];
    [root iterate:@"Urls.Url" usingBlock: ^(RXMLElement *e) {
        [urls setObject:[e description] forKey:[e attribute:@"Name"]];
    }];
    
    [root iterate:@"ServiceMethods.ServiceMethod" usingBlock: ^(RXMLElement *e) {
        
        LMSServiceModel* method = [[LMSServiceModel alloc] init];
        method.name = [e attribute:@"Name"];
        method.method = [e attribute:@"Method"] ? [e attribute:@"Method"] : httpMethod;
        method.timeout = [e attribute:@"Timeout"] ? [[e attribute:@"Timeout"] integerValue] : timeout;
        method.returnType = NSClassFromString([e attribute:@"ReturnType"]);
        method.address = [method assembleAddress:[e attribute:@"Url"] urls:urls];
        method.parameters = [e attribute:@"Parameters"];
        method.commonParameters = commonParameters;
        method.isLoggingEnabled = [e attribute:@"IsLoggingEnabled"] ? [[[e attribute:@"IsLoggingEnabled"] uppercaseString] isEqualToString:@"YES"] : isLoggingEnabled;
        method.timeoutMessage = [e attribute:@"TimeoutMessage"] ? [e attribute:@"TimeoutMessage"] : timeoutMessage;
        method.failbackMessage = [e attribute:@"FailbackMessage"] ? [e attribute:@"FailbackMessage"] : failbackMessage;
        
        method.message = [e attribute:@"Message"] ? [e attribute:@"Message"] : message;
        method.showWaitBox = [e attribute:@"ShowWaitBox"] ? [[[e attribute:@"ShowWaitBox"] uppercaseString]isEqualToString:@"YES"] : showWaitBox;
        [methods setObject:method forKey:method.name];
    }];
}
+ (LMSServiceModel*)methodWithName:(NSString *)methodName {
    
    return [methods objectForKey:methodName];
}
@end
