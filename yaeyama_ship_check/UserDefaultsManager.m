//
//  UserDefaultsManager.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/08/30.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager

+ (Boolean)save:(id) value key:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    [ud setObject:value forKey:key];
    BOOL successful = [ud synchronize];
    if (successful) {
        //        NSLog(@"%@", @"データの保存に成功");
    }
    return successful;
}

+ (Boolean)saveMutableDictonary:(NSMutableDictionary*) value key:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [ud setObject:data forKey:key];
    BOOL successful = [ud synchronize];
    if (successful) {
//        NSLog(@"%@", @"データの保存に成功");
    }
    return successful;
}

+ (id)load:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    return [ud arrayForKey:key];
}

+ (NSMutableDictionary*)loadMutableDictonary:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSData *data = [ud dataForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (Boolean)exist:(NSString*)key {
    NSDictionary* value = [self load:key];
    if (value) {
        return true;
    }
    return false;
}

@end
