//
//  ParserManager.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "ParseManager.h"
#import "HTMLParser.h"
#import "PlistManager.h"

@implementation ParseManager

-(NSString*)getURL {
    return @"https://www.kimonolabs.com/api/2zlj0daa?apikey=8837b24bb3227808960e619d2994643f";
}

- (NSMutableArray*)htmlParsYKF
{
    NSString* url = [self getURL];
    NSData* dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString* string = [[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSMutableArray* result = [NSMutableArray array];
    HTMLParser* parser = [[HTMLParser alloc] initWithString:string error:&error];
    HTMLNode* bodyNode = [parser body];
    NSCharacterSet* space = [NSCharacterSet whitespaceCharacterSet];
    
    NSArray* trNodes = [bodyNode findChildTags:@"tr"]; //divタグのみを抽出
    for (HTMLNode* node in trNodes) {
        
        NSArray* spanNodes = [node findChildTags:@"span"];
        HTMLNode* portNode = [spanNodes objectAtIndex:0];
        HTMLNode* statusNode = [spanNodes objectAtIndex:1];
        HTMLNode* commentNode = [spanNodes objectAtIndex:2];
        
        NSString* port = [[portNode contents] stringByTrimmingCharactersInSet:space];
        NSString* status = [[statusNode contents] stringByTrimmingCharactersInSet:space];
        NSString* comment = [[commentNode contents] stringByTrimmingCharactersInSet:space];
        
        if ([port length] > 0 || port != nil || [status length] > 0 || status != nil) {
            
            NSDictionary* node = @{ @"port" : port,
                                    @"status" : status,
                                    @"comment" : comment };
            [result addObject:node];
        }
    }
    return result;
}

@end
