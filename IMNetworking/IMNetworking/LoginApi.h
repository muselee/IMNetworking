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
@property (copy,nonatomic)NSString * msg;
@property (copy,nonatomic)NSString * email;


+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
           susessCallBack:(void(^)(LoginApi * response))successCallBack
             failCallback:(void(^)(LMSServiceError * error))failCallback;
@end
