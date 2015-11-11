//
//  ServiceMetadata.h
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//
/// 解析xml类
#import <Foundation/Foundation.h>
@class LMSServiceModel;
@interface LMSServiceXMLData : NSObject
/**
 *  获取请求Model类
 *
 *  @param methodName 请求的名字
 *
 *  @return Model 对象
 */
+ (LMSServiceModel*)methodWithName:(NSString*) methodName;
@end
