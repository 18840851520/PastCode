//
//  ViewController.m
//  ICETest
//
//  Created by 划落永恒 on 2018/12/17.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "ViewController.h"
#import <objc/Ice.h>
#import <objc/Glacier2.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ICEInitializationData* initData = [ICEInitializationData initializationData];
    
    initData.properties = [ICEUtil createProperties];
    [initData.properties load:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"config.client"]];
    [initData.properties setProperty:@"Ice.ACM.Client.Timeout" value:@"0"];
    [initData.properties setProperty:@"Ice.RetryIntervals" value:@"-1"];
    
    initData.dispatcher = ^(id<ICEDispatcherCall> call, id<ICEConnection> con)
    {
        dispatch_sync(dispatch_get_main_queue(), ^ { [call run]; });
    };
}


@end
