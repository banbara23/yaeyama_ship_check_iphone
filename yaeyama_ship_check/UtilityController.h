//
//  UtilityController.h
//  航路お知らせ
//
//  Created by banbaraniisan on 2014/06/05.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityController : NSObject

+(NSString*)getKimonoURL:(int)comapny_id;
+(NSString*)getPortIdName:(NSString*)portid;
+(NSString*)getStatusName:(int)status;
+(NSString*)run_id;
+(NSString*)getCompanyName:(int)comapny_id;
+(NSString*)getPortId:(NSString*)portName;
+(NSString*)getToday;

@end
