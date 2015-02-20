//
//  AneiDetailParser.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "AneiDetailStatus.h"
#import "AneiStatus.h"

@interface AneiDetailParser : NSObject

-(AneiDetailStatus*)getPasrsData:(NSString*)url;

@end
