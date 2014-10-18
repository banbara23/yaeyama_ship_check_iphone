//
//  ANNEI.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/09/24.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "ANNEI.h"
#import "UserDefaultsManager.h"

static NSString *const kSAVE_KEY_HEADER = @"header_anei";
static NSString *const kSAVE_KEY_BODY = @"body_anei";

@implementation ANNEI

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

@end
