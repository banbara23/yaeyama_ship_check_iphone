//
//  UtilityController.m
//  航路お知らせ
//
//  Created by banbaraniisan on 2014/06/05.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "UtilityController.h"

@implementation UtilityController

+(NSString*)getKimonoURL:(int)comapny_id {

    if (comapny_id == 0) {
        //安栄
        return @"https://www.kimonolabs.com/api/2zlj0daa?apikey=8837b24bb3227808960e619d2994643f";
    }
    else if (comapny_id == 1) {
        //八重山観光
        return @"https://www.kimonolabs.com/api/55fmpydq?apikey=8837b24bb3227808960e619d2994643f";
    }
    else if (comapny_id == 2) {
        //石垣ドリーム
        return @"https://www.kimonolabs.com/api/c82ztzdg?apikey=8837b24bb3227808960e619d2994643f";
    }
    return nil;
}

+ (NSString *)decodeJSONString:(NSString *)input
{
    
    NSString *esc1 = [input stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData *data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
    NSString *unesc = [NSPropertyListSerialization propertyListFromData:data
                                                       mutabilityOption:NSPropertyListImmutable format:NULL
                                                       errorDescription:NULL];
    assert([unesc isKindOfClass:[NSString class]]);
    return unesc;
}

/**
 *  港名を返す
 */
+(NSString*)getPortIdName:(NSString*)portid {
    NSString *portName;

    if ([portid isEqualToString:@"0"]) {
        portName = @"石垣";
    }
    else if ([portid isEqualToString:@"1"]) {
        portName = @"大原";
    }
    else if ([portid isEqualToString:@"2"]) {
        portName = @"上原";
    }
    else if ([portid isEqualToString:@"3"]) {
        portName = @"竹富";
    }
    else if ([portid isEqualToString:@"4"]) {
        portName = @"小浜";
    }
    else if ([portid isEqualToString:@"5"]) {
        portName = @"黒島";
    }
    else if ([portid isEqualToString:@"6"]) {
        portName = @"波照間";
    }
    else if ([portid isEqualToString:@"7"]) {
        portName = @"鳩間";
    }
    else if ([portid isEqualToString:@"8"]) {
        portName = @"プレミアムドリーム";
    }
    else if ([portid isEqualToString:@"9"]) {
        portName = @"スーパードリーム";
    }
    
    return portName;
}

/**
 *  port_idを返す
 */
+(NSString*)getPortId:(NSString*)portName {
    NSString *portId;
    if ([portName rangeOfString:@"鳩間"].location != NSNotFound) {
        portId = @"7";
    }
    else if ([portName rangeOfString:@"波照間"].location != NSNotFound) {
        portId = @"6";
    }
    else if ([portName rangeOfString:@"黒島"].location != NSNotFound) {
        portId = @"5";
    }
    else if ([portName rangeOfString:@"小浜"].location != NSNotFound) {
        portId = @"4";
    }
    else if ([portName rangeOfString:@"竹富"].location != NSNotFound) {
        portId = @"3";
    }
    else if ([portName rangeOfString:@"上原"].location != NSNotFound) {
        portId = @"2";
    }
    else if ([portName rangeOfString:@"大原"].location != NSNotFound) {
        portId = @"1";
    }
    else if ([portName rangeOfString:@"石垣"].location != NSNotFound) {
        portId = @"0";
    }
    return portId;
}

/**
 *  ステータス名を返す
 */
+(NSString*)getStatusName:(int)status
{
    NSString *statusName;
    switch (status) {
        case 1:
            statusName = @"○ 運航";
            break;
            
        case 2:
            statusName = @"× 欠航";
            break;
            
        case 3:
            statusName = @"△ 未定";
            break;
            
        case 4:
            statusName = @"運休日";
            break;
            
        default:
            statusName = @"不明";
            break;
    }
    return statusName;
}

//会社名取得　（ステータス画面)
+(NSString*)getCompanyName:(int)comapny_id {

    NSString* name;
    switch (comapny_id) {
        case 0:
            name = @"安栄観光";
            break;
            
        case 1:
            name = @"八重山観光フェリー";
            break;
            
        case 2:
            name = @"石垣ドリーム";
            break;
            
        default:
            break;
    }
    return name;
}

//会社名取得　（時間表画面)
+(NSString*)getCompanyNameAll:(int)comapny_id {
    
    NSString* name;
    switch (comapny_id) {
        case 0:
            name = @"全て";
            break;           
            
        case 1:
            name = @"安栄観光";
            break;
            
        case 2:
            name = @"八重山観光フェリー";
            break;
            
        case 3:
            name = @"石垣ドリーム";
            break;
        
        default:
            break;
    }
    return name;
}

/**
 *  run_idを作成
 *
 *  @return YYYYMMDD形式
 */
+(NSString*)run_id
{
    NSString* date_converted;
    NSDate* date_source = [NSDate date];
    
    // NSDateFormatter を用意します。
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    // 変換用の書式を設定します。
    [formatter setDateFormat:@"YYYYMMdd"];
    
    // NSDate を NSString に変換します。
    date_converted = [formatter stringFromDate:date_source];
    return date_converted;
}

//タイトル用の今日の日付を作成
+(NSString*)getToday {
    NSString* date_converted;
    NSDate* date_source = [NSDate date];
    
    // NSDateFormatter を用意します。
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    // 変換用の書式を設定します。
    [formatter setDateFormat:@"M月d日"];
    
    // NSDate を NSString に変換します。
    date_converted = [formatter stringFromDate:date_source];
    return date_converted;
}

@end
