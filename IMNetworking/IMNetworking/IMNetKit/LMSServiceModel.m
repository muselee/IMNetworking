//
//  ServiceMethod.m
//  IMNetKit
//
//  Created by liqian on 15/11/10.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "LMSServiceModel.h"
@interface LMSServiceModel(){
    NSString * _absoluteUrl;
    NSString* _urlID;
    NSString* _urlVerb;
}
@property (strong,nonatomic)NSArray *parameterNames;
@end
@implementation LMSServiceModel


- (NSString *)assembleAddress:(NSString *)address urls:(NSDictionary *)urlsDic{
    if ([address characterAtIndex:0] != '[') {
        _absoluteUrl = address;
    }
    else {
        
        NSInteger positionOfRightBracket = [address rangeOfString:@"]"].location;
        _urlID = [address substringWithRange:NSMakeRange(1, positionOfRightBracket - 1)];
        if ([address characterAtIndex:address.length - 1] != ']') {
            _urlVerb = [address substringFromIndex:positionOfRightBracket + 1];
        }
    }
    NSString* baseUrl = _urlID ? [urlsDic objectForKey:_urlID] : _absoluteUrl;
    NSMutableString* urlString = [[NSMutableString alloc] init];
    
    [urlString appendString:baseUrl];
    [urlString appendString:_urlVerb];
    return urlString;

}
-(NSDictionary *)assembleParametersWithValues:(NSArray *)values{
    if (_parameters.length>0) {
        NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc]init];
        _parameterNames = [[NSMutableArray alloc] init];
        _parameterNames = [_parameters componentsSeparatedByString:@","];
        [_parameterNames enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * value = values[idx];
            [parameterDic setValue:value forKey:key];
        }];
        return parameterDic;
    }
    return nil;
}

-(NSString*) messageForError:(NSError *) error {
    
    if (error.code == -1001 && _timeoutMessage) {
        return _timeoutMessage;
    }
    else {
        NSDictionary *userInfo = [error userInfo];
        NSString *description = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
        
        if (!description || description.length == 0) {
            description = _failbackMessage;
        }
        
        return description;
    }
}

@end
