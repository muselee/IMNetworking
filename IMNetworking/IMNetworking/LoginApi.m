//
//  LoginApi.m
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"email":@"res.email"
             };
}

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password susessCallBack:(void (^)(LoginApi *))successCallBack failCallback:(void (^)(ServiceError *))failCallback{
    Request * request=[Request create:@"Login" parameterValues:@[userName,password]];
    [request send:successCallBack failCallback:failCallback];
}
@end
