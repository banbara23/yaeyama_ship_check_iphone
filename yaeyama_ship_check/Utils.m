//
//  Utils.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void)putLog:(NSString*)value
{
    NSLog(@"%@",value);
}

//今日の日付を作成 例：@"M月d日"
+(NSString*)getTodayString:(NSString*)stringFormat
{
    NSString* date_converted;
    NSDate* date_source = [NSDate date];
    
    // NSDateFormatter を用意します。
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    // 変換用の書式を設定します。
    [formatter setDateFormat:stringFormat];
    
    // NSDate を NSString に変換します。
    date_converted = [formatter stringFromDate:date_source];
    return date_converted;
}

//回線状況チェック
+(BOOL)isNetworkEnabled {
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            //インターネット接続出来ません
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

//アラート表示
+(void)showAlaertView:(NSString*)msg {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"お知らせ" message:msg
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
}

//空白を空文字に置き換える
+ (NSString*)stringByReplaceEmpty:(NSString*)string
{
    if ([self isEmpty:string]) {
        return @"";
    }
    string = [string stringByReplacingOccurrencesOfString:@"　" withString:@""];
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(BOOL)isEmpty:(NSString*)string
{
    if (!string || string.length == 0) {
        return true;
    }
    return false;
}

+(BOOL)isNotEmpty:(NSString*)string
{
    return ![self isEmpty:string];
}

+(BOOL)isEmptyMutableArray:(NSMutableArray*)array
{
    if (!array || array.count == 0) {
        return true;
    }
    return false;
}

+(BOOL)isEmptyArray:(NSArray*)array
{
    if (!array || array.count == 0) {
        return true;
    }
    return false;
}

+(PortType)convertToPortType:(NSString*)string {
    if ([string rangeOfString:@"石垣"].location != NSNotFound) {
        return ishigaki;
    }
    if ([string rangeOfString:@"竹富"].location != NSNotFound) {
        return taketomi;
    }
    if ([string rangeOfString:@"小浜"].location != NSNotFound) {
        return kohama;
    }
    if ([string rangeOfString:@"黒島"].location != NSNotFound) {
        return kuroshima;
    }
    if ([string rangeOfString:@"大原"].location != NSNotFound) {
        return oohara;
    }
    if ([string rangeOfString:@"上原"].location != NSNotFound) {
        return uehara;
    }
    if ([string rangeOfString:@"波照間"].location != NSNotFound) {
        return hateruma;
    }
    if ([string rangeOfString:@"鳩間"].location != NSNotFound) {
        return hatoma;
    }
    return ishigaki;
}

+(UIColor*)getCommentTextColor:(CssClassType)cssClassType {
    switch (cssClassType) {
        case nomal:
            return [UIColor blueColor];
            break;
        case cancel:
            return [UIColor redColor];
            break;
    }
}

+(NSString*)getDetailUrl:(PortType)portType {
    switch (portType) {
        case taketomi:
            return ANEI_DETAIL_TAKETOMI_PARSER_URL;
            break;
        case kohama:
            return ANEI_DETAIL_KOHAMA_PARSER_URL;
            break;
        case kuroshima:
            return ANEI_DETAIL_KUROSHIMA_PARSER_URL;
            break;
        case oohara:
            return ANEI_DETAIL_OOHARA_PARSER_URL;
            break;
        case uehara:
            return ANEI_DETAIL_UEHARA_PARSER_URL;
            break;
        case hateruma:
            return ANEI_DETAIL_HATERUMA_PARSER_URL;
            break;
        case hatoma:
            return ANEI_DETAIL_HATOMA_PARSER_URL;
            break;
        default:
            return nil;
            break;
    }
}

//cssの色をEnumに変換
+ (CssClassType)convertToCssClassType:(NSString*)string {
    if ([string rangeOfString:@"normal"].location != NSNotFound) {
        return nomal;
    }
    if ([string rangeOfString:@"cancel"].location != NSNotFound) {
        return cancel;
    }
    return cancel;
}

@end
