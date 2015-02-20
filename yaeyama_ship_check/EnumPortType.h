//
//  EnumPortType.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnumPortType : NSObject

typedef NS_ENUM(NSInteger, PortType)
{
    ishigaki = 0,
    taketomi = 1,
    kohama = 2,
    kuroshima = 3,
    oohara = 4,
    uehara = 5,
    hateruma = 6,
    hatoma = 7
};
@end
