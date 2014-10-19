//
//  DreamConverter.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/14.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "DreamConverter.h"
#import "DREAM.h"

@implementation DreamConverter {
    NSDictionary *results;
    NSArray *ports;
    NSMutableArray *convertData;
}

-(id)initWithResult:(NSDictionary*)_results {
    if (self == [super init]) {
        results = _results;
        convertData = [[NSMutableArray alloc]init];
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
    NSArray *keys = [self createKeys];

    for (id key in keys) {
        NSArray *temp = [results objectForKey:key];
        NSDictionary *value = [temp objectAtIndex:0];
        [convertData addObject:value];
//        NSString *port = [value objectForKey:@"port"];
//        NSString *status = [value objectForKey:@"status"];
    }
    [DREAM setBody:convertData];
}

-(NSArray*)createKeys {
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
