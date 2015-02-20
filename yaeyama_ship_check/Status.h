//
//  Status.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumPortType.h"
#import "EnumCssClassType.h"

@interface Status : NSObject

@property NSString *portName;
@property NSString *comment;
@property CssClassType cssClassType;
@property PortType portType;

@end
