//
//  RUN_STATUS.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/30.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUN_STATUS : NSObject

@property int run_id;
@property (nonatomic, strong) NSString* port_id_start;
@property (nonatomic, strong) NSString* port_id_end;
@property int sort_no;
@property int status;
@property (nonatomic, strong) NSString* createDate;
@property (nonatomic, strong) NSString* updateDate;
@property (nonatomic, strong) NSString* company_id;

@end
