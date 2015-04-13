//
//  YkfParser.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/11/12.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

/*
 2015/2/21 memo
 上原と鳩間のみ運行状況のタグ位置が違う
 
2015-02-21 13:17:56.945 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:17:56.946 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:17:56.946 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 平成27年 2月21日 （土）
2015-02-21 13:17:56.946 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:17:56.946 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:01.404 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 竹富航路
2015-02-21 13:18:01.404 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: ○
2015-02-21 13:18:01.404 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:18:01.405 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:01.405 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:02.411 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 小浜航路
2015-02-21 13:18:02.412 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: ○
2015-02-21 13:18:02.412 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:18:02.412 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:02.412 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:03.357 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 黒島航路
2015-02-21 13:18:03.358 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: ○
2015-02-21 13:18:03.358 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:18:03.358 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:03.358 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:04.242 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 大原航路
2015-02-21 13:18:04.242 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: ○
2015-02-21 13:18:04.243 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:18:04.243 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:04.243 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:04.992 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 上原航路
2015-02-21 13:18:04.992 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72:         <-半角スペースがかえってくる
2015-02-21 13:18:04.992 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 〇
2015-02-21 13:18:04.992 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:18:04.993 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:18:04.993 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:19:18.235 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 鳩間航路
2015-02-21 13:19:18.236 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72:         <-半角スペースにかえってくる
2015-02-21 13:19:18.236 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 〇
2015-02-21 13:19:18.236 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: 通常運航
2015-02-21 13:19:18.236 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
2015-02-21 13:19:18.237 yaeyama_ship_check[17208:1105016] DEBUG: -[YkfParser createStatus:]:72: (null)
*/

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
        HTMLNode* commentNode = [spanNodes objectAtIndex:2];    //上原と鳩間のみここが半角スペースとなる
        HTMLNode* commentNode2 = [spanNodes objectAtIndex:3];   //空のspanタグ対策

//        for (HTMLNode* n in spanNodes) {
//            NSLog(@"%@",[n contents]);
//        }
        
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
