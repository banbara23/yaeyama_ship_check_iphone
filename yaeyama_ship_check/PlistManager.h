//
//  PlistManager.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/08/30.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistManager : NSObject

+(Boolean)save:(NSDictionary*) value saveKey:(NSString*)key;
+(NSDictionary*)load:(NSString*)key;

@end
