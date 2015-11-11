//
//  ServiceError.h
//  IMNetKit
//
//  Created by liqian on 15/11/11.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,ServiceErrorType) {
    ServiceErrorTypeHttp,
    ServiceErrorTypeNetwork,
    ServiceErrorTypeParsing
};
@interface ServiceError : NSObject
@property (retain, nonatomic) NSString* message;
@property (nonatomic) NSInteger httpCode;
@property (nonatomic) NSInteger errorType;
@end
