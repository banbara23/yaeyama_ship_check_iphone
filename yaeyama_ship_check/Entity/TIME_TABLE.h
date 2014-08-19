//
//  TIME_TABLE.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/30.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TIME_TABLE : NSObject

@property int table_id;
@property (nonatomic, strong) NSString* company_id;
@property (nonatomic, strong) NSString* port_id_start;
@property (nonatomic, strong) NSString* port_id_end;
@property (nonatomic, strong) NSString* time;
@property int via_type;
@property int sort_no;
@property (nonatomic, strong) NSString* createData;
@property (nonatomic, strong) NSString* updateData;

@end
