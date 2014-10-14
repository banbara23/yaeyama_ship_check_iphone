//
//  AneiConverter.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/14.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "AneiConverter.h"

@implementation AneiConverter

-(id)initWithResult:(NSDictionary*)_results {
    if (self == [super init]) {
        results = _results;
        convertData = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)convert {
//    [self convertHeader];
    [self convertBody];
}

//今は使わない
-(void)convertHeader {
    NSDictionary *header = [[NSDictionary alloc]init];
    header = [results objectForKey:@"header"];
    NSLog(@"header %@",header);
    
}

//一覧表示用
-(void)convertBody {
    NSDictionary *value = [[NSDictionary alloc]init];
    value = [results objectForKey:@"value"];
    NSLog(@"value %@",value);
    NSDictionary *status = [value objectForKey:@"status"];
    NSLog(@"%@",status);
    NSString *text = [status objectForKey:@"text"];
    NSString *port = [value objectForKey:@"port"];
}

@end
