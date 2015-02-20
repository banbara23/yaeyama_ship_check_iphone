//
//  YkfParser.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/11/12.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "YkfParser.h"

@interface YkfParser () {
    NSMutableArray *result;
}
@end

@implementation YkfParser

/*
 * 指定したURLからHTMLソースをパースする
 */
- (YkfStatus*)getParsData
{
    NSString* url = YKF_PARS_URL;
    NSData* dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString* string = [[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);
    NSError* error = nil;
    result = [NSMutableArray array];
    HTMLParser* parser = [[HTMLParser alloc] initWithString:string error:&error];
    HTMLNode* bodyNode = [parser body];
    YkfStatus *ykf = [[YkfStatus alloc]init];
    //更新日時
    ykf.groupTitle = [self createGroupTitle:bodyNode];
    //運航状況
    ykf.statusArray = [self createStatus:bodyNode];
    
    return ykf;
}

//更新日時のみ取得
- (NSString*)createGroupTitle:(HTMLNode*)bodyNode {
    //更新日時を取得
    NSString *updateText = @"";
    NSArray *pNodes = [bodyNode findChildTags:@"p"];    //pタグのみを抽出
    if (!pNodes) {
        return @"";
    }
    HTMLNode *pNode = [pNodes objectAtIndex:2];
    NSArray *spanNodes = [pNode findChildTags:@"span"]; //spanタグのみを抽出
    if (!spanNodes) {
        return @"";
    }
    for (HTMLNode *node in spanNodes) {
        updateText = [updateText stringByAppendingString:[node contents]];
    }
    return updateText;
}

//運航状況を取得
- (NSMutableArray*)createStatus:(HTMLNode*)bodyNode {
    NSArray* trNodes = [bodyNode findChildTags:@"tr"]; //divタグのみを抽出
    for (HTMLNode* node in trNodes) {
        
        NSArray* spanNodes = [node findChildTags:@"span"];
        HTMLNode* portNode = [spanNodes objectAtIndex:0];
        HTMLNode* statusNode = [spanNodes objectAtIndex:1];
        HTMLNode* commentNode = [spanNodes objectAtIndex:2];
        HTMLNode* commentNode2 = [spanNodes objectAtIndex:3];   //空のspanタグ対策
        NSString* port = [Utils stringByReplaceEmpty:[portNode contents]];
        NSString* status = [Utils stringByReplaceEmpty:[statusNode contents]];
        NSString* comment = [Utils stringByReplaceEmpty:[commentNode contents]];
        
        //上原と鳩間のみ空の<span>タグが2番目に出てくる場合、なぜか3番目に値が入っている、謎の仕様 2/8
        if ([Utils isEmpty:status]) {
            comment = [Utils stringByReplaceEmpty:[commentNode2 contents]];
        }
        if ([Utils isNotEmpty:port] || [Utils isNotEmpty:comment]) {
            
            Status *status = [[Status alloc]init];
            status.portName = port;
            status.comment = comment;
            status.cssClassType = [self convertToCssClassType:comment];
            status.portType = [Utils convertToPortType:port];
            
            [result addObject:status];
        }
    }
    return result;
}

//cssの色をEnumに変換
- (CssClassType)convertToCssClassType:(NSString*)string {
    if ([string rangeOfString:@"通常運航"].location != NSNotFound) {
        return nomal;
    }
    return cancel;
}

@end
