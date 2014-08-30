//
//  PlistManager.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/08/30.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "PlistManager.h"

@implementation PlistManager

//-(NSString*)getFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *directory = [paths objectAtIndex:0];
//    return [directory stringByAppendingPathComponent:@"yaeyama_ship_check-Info.plist"];
//}

+(Boolean)save:(NSDictionary*) value saveKey:(NSString*)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"yaeyama_ship_check-Info.plist"];
    
    BOOL successful = [value writeToFile:filePath atomically:NO];
    
    if (successful) {
        NSLog(@"%@", @"データの保存に成功");
    }
    return successful;
}

+(NSDictionary*)load:(NSString*)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"yaeyama_ship_check-Info.plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}

@end
