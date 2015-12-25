//
//  ViewController.m
//  IMNetworking
//
//  Created by liqian on 15/11/11.
//  Copyright © 2015年 LQ. All rights reserved.
//

#import "ViewController.h"
#import "LoginApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LoginApi loginWithUserName:@"chengqing" password:@"123456" susessCallBack:^(LoginApi *response) {
        NSLog(@"success %@",response);
    } failCallback:^(LMSServiceError *error) {
        NSLog(@"fail %@",error.message);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
