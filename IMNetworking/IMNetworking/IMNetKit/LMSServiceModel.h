//
//  ServiceMethod.h
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//
/**
 *  server 实体类  用来保存请求配置信息，以及参数 返回处理
 *
 */
#import <Foundation/Foundation.h>

@interface LMSServiceModel : NSObject

@property (copy, nonatomic) NSString * name;

@property (copy, nonatomic) NSString * method;

@property (copy, nonatomic) NSString * address;

@property (copy, nonatomic) NSString * parameters;

@property (nonatomic) NSInteger timeout;

@property (strong, nonatomic) Class returnType;

@property (copy, nonatomic) NSString * timeoutMessage;

@property (copy, nonatomic) NSString * failbackMessage;

@property (nonatomic) BOOL isLoggingEnabled;

@property (retain, nonatomic) NSString* message;

@property (nonatomic) BOOL showWaitBox;

@property (copy,nonatomic) NSString * commonParameters;

- (NSString *)assembleAddress:(NSString*)address urls:(NSDictionary *) urlsDic;

- (NSMutableDictionary *)assembleParametersWithValues:(NSArray *)values;

- (NSMutableDictionary *)assembleCommonParametersWithValues:(NSArray *)values;

- (NSString*)messageForError:(NSError*) error;
@end
