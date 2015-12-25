//
//  LoginApi.h
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMSRequest.h"
@interface LoginApi : NSObject
@property (copy,nonatomic)NSString * code;
@property (copy,nonatomic)NSString * message;
@property (copy,nonatomic)NSDictionary * data;

+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
           susessCallBack:(void(^)(LoginApi * response))successCallBack
             failCallback:(void(^)(LMSServiceError * error))failCallback;
@end
