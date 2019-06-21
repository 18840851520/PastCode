//
//  UserData.m
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (BOOL)saveData:(id)data ForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (data) {
        [defaults setObject:data forKey:key];
    }else{
        [defaults setValue:data forKey:key];
    }
    return [defaults synchronize];
}
+ (id)getDataForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id data = [defaults objectForKey:key];
    return data;
}
@end
