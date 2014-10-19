//
//  YKF.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKF : NSObject

+ (NSString*)getKey;
+ (void)setHeader:(NSDictionary*)value;
+ (void)setBody:(NSDictionary*)value;
+ (NSDictionary*)getHeader;
+ (NSDictionary*)getBody;
+ (BOOL)exist;
+ (void)init;

@end
