//
//  AneiStatusDetail.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AneiStatus.h"

@interface AneiDetailStatus : NSObject

//@property (strong, nonatomic) NSString *groupTitleFromIshigaki;
//@property (strong, nonatomic) NSString *groupTitleToIshigaki;
//@property (strong, nonatomic) NSMutableArray *statusArrayFromIshigaki;
//@property (strong, nonatomic) NSMutableArray *statusArrayToIshigaki;

@property AneiStatus *aneiStatusFromIshigaki;
@property AneiStatus *aneiStatusToIshigaki;

@end
