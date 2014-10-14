//
//  DBController.h
//  0418_辞書アプリ
//
//  Created by 池村　和剛 on 2014/04/22.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDatabase.h"
//#import "DBItems.h"

@interface DBManager : NSObject

+ (DBManager*)sharedInstance;
- (BOOL)openDatabase;
-(void)closeDatabase;

- (void)insertItem:(NSArray*)items tableName:(NSString*)name;
- (void)updateRUN_STATUS:(NSDictionary*)dic;


- (NSArray *)selectAllItem:(NSString *)sql;
- (NSArray*)selectPORT_MASTER;
- (NSArray*)selectRUN_STATUS:(NSString*)company_id;
-(void)setResponseResult:(NSDictionary*)response;

@end

