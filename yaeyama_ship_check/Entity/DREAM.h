//
//  DREAM.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DREAM : NSObject

+ (void)saveResponse:(id)value;
+ (NSDictionary*)getResponse;

+ (void)setHeader:(id)value;
+ (void)setBody:(NSDictionary*)value;
+ (id)getHeader;
+ (NSMutableDictionary*)getBody;
+ (Boolean)exist;
+ (void)init;
+ (NSArray*)getKeys;

@end
