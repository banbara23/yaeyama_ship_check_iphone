//
//  ParserManager.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2014/10/09.
//  Copyright (c) 2014年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@interface ParseManager : NSObject
- (NSMutableArray*)htmlParsYKF;
- (HTMLNode*)loadHtml:(NSString*)url;
@end
