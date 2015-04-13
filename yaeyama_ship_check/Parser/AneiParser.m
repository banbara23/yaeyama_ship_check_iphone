//
//  AneiParser.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/11/12.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import "AneiParser.h"
#import "HTMLNode.h"
#import "Status.h"

@implementation AneiParser

/*
 * 指定したURLからHTMLソースをパースする
 */
-(AneiStatus*)getPasrsData {
    NSString *url = ANEI_PARS_URL;
    NSData *dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *string = [[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:string error:&error];
    HTMLNode *bodyNode = [parser body];
    AneiStatus *anei = [[AneiStatus alloc]init];
    
    anei.groupTitle = [self createGroupTitle:bodyNode]; //更新日時、コメント
    anei.statusArray = [self createStatusArray:bodyNode];           //運航状況

    return anei;
}

//更新日時、コメント取得
- (NSString*)createGroupTitle:(HTMLNode*)bodyNode {
    NSString *updateDateText = [self getUpdateDateText:bodyNode];
    NSString *commentText = [self getComment:bodyNode];
    return [updateDateText stringByAppendingString:commentText];
}

//更新日時のみ取得
- (NSString*)getUpdateDateText:(HTMLNode*)bodyNode {
    NSString *updateText = @"";
    NSArray *h4Nodes = [bodyNode findChildTags:@"h4"];    //h4タグのみを抽出
    if (h4Nodes) {
        HTMLNode *h4Node = [h4Nodes objectAtIndex:0];
        updateText = [h4Node contents];

        NSArray *stongNodes = [h4Node findChildTags:@"strong"];    //strongタグのみを抽出
        if (stongNodes.count > 0) {
            HTMLNode *stongNode = [stongNodes objectAtIndex:0];
            updateText = [updateText stringByAppendingString:[stongNode contents]];
        }
    }
    return [updateText stringByAppendingString:@"\n"];
}

//コメント取得
- (NSString*)getComment:(HTMLNode*)bodyNode {
    NSString *commentText = @"";
    NSArray *h5Nodes = [bodyNode findChildTags:@"h5"];    //h5タグのみを抽出
    if (h5Nodes) {
        HTMLNode *h5Node = [h5Nodes objectAtIndex:0];
        commentText = [h5Node contents];
        if (commentText) {
            commentText = [@"\n" stringByAppendingString:commentText];  //改行を文頭に追加
        }
    }
    commentText = [Utils stringByReplaceEmpty:commentText];
    return [Utils stringByDevineMutableArray:commentText];
}

//運航状況を取得
- (NSMutableArray*)createStatusArray:(HTMLNode*)bodyNode {
    //運航状況を取得
    NSArray *divNodes = [bodyNode findChildTags:@"div"];    //divタグのみを抽出
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (HTMLNode *node in divNodes) {
        //クラス名が「route clearfix」と一致するものを抽出
        if([[node getAttributeNamed:@"class"] isEqualToString:@"route clearfix"])
        {
            //h6タグ 港名
            NSArray *h6Nodes = [node findChildTags:@"h6"];
            HTMLNode *h6Node = [h6Nodes objectAtIndex:0];
            
            //aタグ　運航状況
            NSArray *aNodes = [node findChildTags:@"a"];
            HTMLNode *aNode = [aNodes objectAtIndex:0];
            
            //pタグ　クラス名
            NSArray *pNodes = [node findChildTags:@"p"];
            HTMLNode *pNode = [pNodes objectAtIndex:0];
            
            Status *status = [[Status alloc]init];
            status.portName = [h6Node contents];
            status.comment = [aNode contents];
            status.cssClassType = [Utils convertToCssClassType:[pNode className]];
            status.portType = [Utils convertToPortType:[h6Node contents]];
            
            [result addObject:status];
        }
    }
    return result;
}

@end
