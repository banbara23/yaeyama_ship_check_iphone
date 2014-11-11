//
//  AneiParser.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/11/12.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "AneiParser.h"
#import "ParseManager.h"

@implementation AneiParser

-(HTMLNode*)getParsHtml {
    ParseManager *parsManager = [[ParseManager alloc]init];
    NSString *url = @"";
    return [parsManager loadHtml:url];
}

-(NSMutableDictionary*)getTableData {
    HTMLNode *bodyNode = [self getParsHtml];
    return nil;
}
@end
