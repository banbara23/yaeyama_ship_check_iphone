//
//  DREAM.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "DREAM.h"

@implementation DREAM

-(id)getValue {
    NSDictionary *results = [UserDefaultsManager load:@"dream"];
    
    return [results objectForKey:@"value"];
}

@end
