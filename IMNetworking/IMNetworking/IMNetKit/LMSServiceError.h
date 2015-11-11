//
//  ServiceError.h
//  IMNetKit
//
//  Created by liqian on 15/11/11.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,LMSServiceErrorType) {
    LMSServiceErrorTypeHttp,
    LMSServiceErrorTypeNetwork,
    LMSServiceErrorTypeParsing
};
@interface LMSServiceError : NSObject
@property (copy, nonatomic) NSString * message;
@property (nonatomic) NSInteger httpCode;
@property (nonatomic) NSInteger errorType;
@end
