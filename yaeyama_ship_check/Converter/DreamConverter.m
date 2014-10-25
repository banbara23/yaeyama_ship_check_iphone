//
//  DreamConverter.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/14.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "DreamConverter.h"
#import "DREAM.h"
#import "Consts.h"

@implementation DreamConverter {
    NSDictionary *results;
    NSArray *ports;
    NSMutableDictionary *convertData;
}

-(id)init {
    if (self == [super init]) {
        results = [DREAM getResponse];
        convertData = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)convert {
//    [self convertHeader];
    [self convertBody];
}

//ドリーム観光はHeaderに港名が含まれている
-(void)convertHeader {
    NSDictionary *header = [results objectForKey:@"header"];
    [DREAM setHeader:header];
}

//一覧表示用
-(void)convertBody {
    NSLog(@"results %@",results);
    NSArray *keys = [DREAM getKeys];

    for (id key in keys) {
        NSArray *body1 = [results objectForKey:key];
        NSDictionary *body2 = [body1 objectAtIndex:0];

        NSString *port = [body2 objectForKey:@"port"];
        NSString *status = [body2 objectForKey:@"status"];
        
        [convertData setValue:port forKeyPath:status];

    }
    NSLog(@"convertData %@",convertData);
    [DREAM setBody:convertData];
}


@end
