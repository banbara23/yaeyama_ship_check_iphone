//
//  DREAM.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "DREAM.h"
#import "UserDefaultsManager.h"
#import "Consts.h"

@implementation DREAM

+ (void)saveResponse:(id)value {
    [UserDefaultsManager save:value key:DREAM_KEY];
}

+ (NSDictionary*)getResponse {
    return [UserDefaultsManager load:DREAM_KEY];
}

+ (void)init {
    [self setBody:nil];
}

+ (void)setHeader:(id)value {
    [UserDefaultsManager save:value key:DREAM_HEADER_KEY];
}

+ (void)setBody:(NSArray*)value {
    [UserDefaultsManager save:value key:DREAM_BODY_KEY];
}

+ (id)getHeader {
    return [UserDefaultsManager load:DREAM_HEADER_KEY];
}

+ (NSMutableDictionary*)getBody {
    return [UserDefaultsManager load:DREAM_BODY_KEY];
}

+ (Boolean)exist {
    return [UserDefaultsManager exist:DREAM_KEY];
}

//
//+ (void)saveResponse:(id)value {
//    [UserDefaultsManager save:value key:DREAM_KEY];
//}
//
//+ (void)loadResponse:(id)value {
//    [UserDefaultsManager load:DREAM_KEY];
//}
//
//+ (Boolean)existResponse {
//    return [UserDefaultsManager exist:DREAM_KEY];
//}

//+ (void)init {
//    [self saveResponse:nil];
//}

+ (NSArray*)getKeys {
    NSArray *keys = [NSArray arrayWithObjects:
                     @"taketomi",
                     @"kohama",
                     @"kuroshima",
                     @"oohara",
                     @"uehara",
                     @"premiam",
                     @"super",
                     nil];
    return keys;
}

@end
