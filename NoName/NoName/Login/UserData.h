//
//  UserData.h
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserData : NSObject

+ (BOOL)saveData:(id)data ForKey:(NSString *)key;

+ (id)getDataForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
