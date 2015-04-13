//
//  Utils.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "EnumCssClassType.h"
#import "EnumPortType.h"

@interface Utils : NSObject

+ (void)putLog:(NSString*)value;
+ (NSString*)getTodayString:(NSString*)stringFormat;
+ (BOOL)isNetworkEnabled;
+ (void)showAlaertView:(NSString*)msg;
+ (NSString*)stringByReplaceEmpty:(NSString*)string;
+ (BOOL)isEmpty:(NSString*)string;
+ (BOOL)isNotEmpty:(NSString*)string;
+ (BOOL)isEmptyMutableArray:(NSMutableArray*)array;
+ (BOOL)isEmptyArray:(NSArray*)array;
+ (PortType)convertToPortType:(NSString*)string;
+ (UIColor*)getCommentTextColor:(CssClassType)cssClassType;
+ (NSString*)getDetailUrl:(PortType)portType;
+ (CssClassType)convertToCssClassType:(NSString*)string;
+ (NSString*)stringByDevineMutableArray:(NSString*)string;
+ (NSString*)getPortDescription:(PortType)PortType;

@end
