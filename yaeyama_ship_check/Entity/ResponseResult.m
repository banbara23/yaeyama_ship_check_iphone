//
//  ResponseResult.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/08/28.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "ResponseResult.h"

@interface ResponseResult()

//@property NSDictionary* dicAnnei;
//@property NSDictionary* dicYkf;
//@property NSDictionary* diDream;

@end

@implementation ResponseResult

-(id)init {
    self = [super init];
    if (self) {
        _dicAnnei = [NSDictionary dictionary];
        _dicYkf = [NSDictionary dictionary];
        _dicDream = [NSDictionary dictionary];
    }
    return self;
}

@end
