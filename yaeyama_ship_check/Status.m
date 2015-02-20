//
//  Status.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "Status.h"

@implementation Status
- (id)init
{
    self = [super init];
    if (self) {
        // デフォ値をいれたり、いれなかったりします
        _portName = @"";
        _comment = @"";
        _cssClassType = nomal;
        _portType = ishigaki;
    }
    return self;
}
@end
