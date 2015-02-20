//
//  YkfParser.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/11/12.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "YkfStatus.h"
#import "Status.h"

@interface YkfParser : NSObject

-(YkfStatus*)getParsData;

@end
