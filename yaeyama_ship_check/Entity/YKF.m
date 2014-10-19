//
//  YKF.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "YKF.h"
#import "UserDefaultsManager.h"

@implementation YKF

static NSString *const kSAVE_KEY_HEADER = @"header_ykf";
static NSString *const kSAVE_KEY_BODY = @"body_ykf";

+ (NSString*)getKey {
    return kSAVE_KEY_BODY;
}

+ (void)setHeader:(NSDictionary*)value {
    [UserDefaultsManager save:value key:kSAVE_KEY_HEADER];
}

+ (void)setBody:(NSDictionary*)value {
    [UserDefaultsManager save:value key:kSAVE_KEY_BODY];
}

+ (NSDictionary*)getHeader {
    return [UserDefaultsManager load:kSAVE_KEY_BODY];
}

+ (NSDictionary*)getBody {
    return [UserDefaultsManager load:kSAVE_KEY_BODY];
}

+ (BOOL)exist {
    return [UserDefaultsManager exist:kSAVE_KEY_BODY];
}

+ (void)init {
    [self setBody:nil];
}

@end
