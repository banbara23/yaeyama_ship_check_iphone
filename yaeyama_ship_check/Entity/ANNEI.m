//
//  ANNEI.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/09/24.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "ANNEI.h"

@implementation ANNEI

+(id)getValue {
    NSDictionary *results = [UserDefaultsManager load:@"anei"];
    
    return [results objectForKey:@"value"];
}

@end
