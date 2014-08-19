//
//  COMPANY_MASTER.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/30.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COMPANY_MASTER : NSObject

@property (nonatomic, strong) NSString* company_id;
@property (nonatomic, strong) NSString* name_full;
@property (nonatomic, strong) NSString* name_short;
@property (nonatomic, strong) NSString* url_pc;
@property (nonatomic, strong) NSString* url_mobile;
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSString* longitude;
@property int sort_no;

@end
