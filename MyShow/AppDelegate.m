//
//  AppDelegate.m
//  MyShow
//
//  Created by 花落永恒 on 17/4/20.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "AppDelegate.h"
#import "JHHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"划落永恒");
    
    JHHomeViewController *vc = [[JHHomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
