//
//  PORT_MASTER.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/30.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PORT_MASTER : NSObject

@property (nonatomic, strong) NSString* port_id;
@property (nonatomic, strong) NSString* name;
@property int via_type;
@property int sort_no;

@end

