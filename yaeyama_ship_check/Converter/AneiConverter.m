//
//  AneiConverter.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/14.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "AneiConverter.h"
#import "ANNEI.h"

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
    [self saveConvertData];
//    NSLog(@"%@",[UserDefaultsManager load:@"anei"])
}

//今は使わない
-(void)convertHeader {
    NSDictionary *header = [[NSDictionary alloc]init];
    header = [results objectForKey:@"header"];
    NSLog(@"header %@",header);
    
}

//一覧表示用
-(void)convertBody {
    NSDictionary *values = [results objectForKey:@"value"];
//    NSLog(@"value %@",values);
    
    for (id value in [values objectEnumerator]) {
//         NSLog(@"%@",value);
        NSString *port = [value objectForKey:@"port"];
        
        NSDictionary *status = [value objectForKey:@"status"];
        NSString *text = [status objectForKey:@"text"];
//        NSString *portReplace = [port stringByReplacingOccurrencesOfString:@"航路" withString:@""];
        [convertData setValue:text forKey:[self replacePort:port]];
    }
}

-(NSString*)replacePort:(NSString*)port {
    return [port stringByReplacingOccurrencesOfString:@"航路" withString:@""];
}

-(void)saveConvertData {
    [ANNEI setBody:convertData];
}

@end
