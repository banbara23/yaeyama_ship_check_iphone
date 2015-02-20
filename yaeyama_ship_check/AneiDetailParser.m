//
//  AneiDetailParser.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "AneiDetailParser.h"
#import "EnumCssClassType.h"
#import "Status.h"

//<table>
// <tr>
// <th colspan="2">石垣港発</th>
// </tr>
// <tr>
// <td class="time">07：10</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">08：30</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">09：30</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">11：00</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">13：30</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">15：30 ★</td>
// <td class="cancel">欠航</td>
// </tr>
// <tr>
// <td class="time">16：40</td>
// <td class="cancel">欠航</td>
// </tr>
//</table>

@implementation AneiDetailParser

/*
 * 指定したURLからHTMLソースをパースする
 */
-(AneiDetailStatus*)getPasrsData:(NSString*)url {
    NSData *dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *string = [[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:string error:&error];
    HTMLNode *bodyNode = [parser body];
    NSArray *tableNodes = [bodyNode findChildTags:@"table"];    //tableタグのみを抽出
    if ([Utils isEmptyArray:tableNodes]) {
        return nil;
    }
    HTMLNode *tableNodeFromIshigaki =[tableNodes objectAtIndex:0];
    HTMLNode *tableNodeToIshigaki =[tableNodes objectAtIndex:1];
    
    AneiDetailStatus *aneiDetailStatus = [[AneiDetailStatus alloc]init];
    
    //石垣から来る船
    aneiDetailStatus.aneiStatusFromIshigaki = [self createAneiStatusFromIshigaki:tableNodeFromIshigaki];
    
    //石垣へ向かう船
    aneiDetailStatus.aneiStatusToIshigaki = [self createAneiStatusToIshigaki:tableNodeToIshigaki];
    
    return aneiDetailStatus;
}

- (AneiStatus*)createAneiStatusFromIshigaki:(HTMLNode*)tableNodeFromIshigaki {
    AneiStatus *aneiStatus = [[AneiStatus alloc]init];
    aneiStatus.groupTitle = [self createGroupTitle:tableNodeFromIshigaki];
    aneiStatus.statusArray = [self createStatusArray:tableNodeFromIshigaki];
    return aneiStatus;
}

- (AneiStatus*)createAneiStatusToIshigaki:(HTMLNode*)tableNodeToIshigaki {
    AneiStatus *aneiStatus = [[AneiStatus alloc]init];
    aneiStatus.groupTitle = [self createGroupTitle:tableNodeToIshigaki];
    aneiStatus.statusArray = [self createStatusArray:tableNodeToIshigaki];
    return aneiStatus;
}

//グループテキスト作成
- (NSString*)createGroupTitle:(HTMLNode*)tableNode {
    NSArray *thNodes = [tableNode findChildTags:@"th"];    //thタグのみを抽出
    if (!thNodes) {
        return nil;
    }
    HTMLNode *thNode = [thNodes objectAtIndex:0];
    return [thNode contents];
}

////運航状況を取得
//- (NSMutableArray*)createStatusArray:(HTMLNode*)tableNode {
//    //運航状況を取得
//    NSMutableArray *result = [[NSMutableArray alloc]init];
//    NSArray *tdNodes = [tableNode findChildTags:@"td"];    //trタグのみを抽出
//    if ([Utils isEmptyArray:tdNodes]) {
//        return nil;
//    }
//    for (HTMLNode *tdNode in tdNodes) {
//        Status *status = [[Status alloc]init];
//
//        if([[tdNode getAttributeNamed:@"class"] isEqualToString:@"time"])
//        {
//            status.portName = [tdNode contents];
//        }
//        else {
//            status.comment = [tdNode contents];
//            NSString *className = [tdNode getAttributeNamed:@"class"];
//            status.cssClassType = [Utils convertToCssClassType:className];
//            [result addObject:status];
//        }
//        
//        NSArray *tdNodes = [tdNode findChildTags:@"td"];
//        if ([Utils isEmptyArray:tdNodes]) {
//            return nil;
//        }
//        HTMLNode *timeNode = [tdNodes objectAtIndex:0];
//        HTMLNode *statusNode = [tdNodes objectAtIndex:1];
//
//        
//        status.portName = [timeNode contents];
//        
//        status.cssClassType = [Utils convertToCssClassType:className];
//        status.portType = [Utils convertToPortType:[statusNode className]];
//        
//        [result addObject:status];
//    }
//    return result;
//}

//運航状況を取得
- (NSMutableArray*)createStatusArray:(HTMLNode*)tableNode {
    //運航状況を取得
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSArray *trNodes = [tableNode findChildTags:@"tr"];    //trタグのみを抽出
    if ([Utils isEmptyArray:trNodes]) {
        return nil;
    }
    for (HTMLNode *trNode in trNodes) {
        NSArray *tdNodes = [trNode findChildTags:@"td"];
        if ([Utils isEmptyArray:tdNodes]) {
            continue;   //th用
        }
        HTMLNode *timeNode = [tdNodes objectAtIndex:0];
        HTMLNode *statusNode = [tdNodes objectAtIndex:1];
        NSString *className = [statusNode getAttributeNamed:@"class"];
        
        Status *status = [[Status alloc]init];
        status.portName = [timeNode contents];
        status.comment = [statusNode contents];
        status.cssClassType = [Utils convertToCssClassType:className];
        status.portType = [Utils convertToPortType:[statusNode contents]];
        
        [result addObject:status];
    }
    return result;
}

@end
