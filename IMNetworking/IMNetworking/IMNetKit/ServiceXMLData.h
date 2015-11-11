//
//  ServiceMetadata.h
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//
/// 解析xml类
#import <Foundation/Foundation.h>
@class ServiceModel;
@interface ServiceXMLData : NSObject
+(ServiceModel*)methodWithName:(NSString*) methodName;
@end
