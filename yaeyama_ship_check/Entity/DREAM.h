//
//  DREAM.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DREAM : NSObject

+ (NSString*)getKey;
+ (void)setHeader:(id)value;
+ (void)setBody:(id)value;
+ (id)getHeader;
+ (id)getBody;
+ (BOOL)exist;
+ (void)init;
@end
