//
//  ANNEI.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/09/24.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//
//  コンバート済みの値が保存される
//

#import <Foundation/Foundation.h>

@interface ANNEI : NSObject

+ (NSString*)getKey;
+(void)setHeader:(id)value;
+(void)setBody:(id)value;
+(id)getHeader;
+(id)getBody;
+(BOOL)exist;
+(void)init;

@end
