//
//  DBManager.m
//  0418_辞書アプリ
//
//  Created by 池村　和剛 on 2014/04/22.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "DBManager.h"
#import "PORT_MASTER.h"
#import "COMPANY_MASTER.h"
#import "RUN_STATUS.h"
#import "TIME_TABLE.h"
#import "UtilityController.h"

@implementation DBManager {
    FMDatabase* _db;
}

static DBManager *instance;
NSString* const DB_FILE = @"ship_db.sqlite";

/**
 * シングルトン
 */
+ (DBManager*)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)openDatabase
{
    //DBファイルへのパスを取得
    //パスは~/Documents/配下に格納される。
    NSString* dbPath = nil;
    NSArray* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //取得データ数を確認
    if ([documentsPath count] >= 1) {
        //固定で0番目を取得でOK
        dbPath = [documentsPath objectAtIndex:0];
        //パスの最後にファイル名をアペンドし、DBファイルへのフルパスを生成。
        dbPath = [dbPath stringByAppendingPathComponent:DB_FILE];
        //        NSLog(@"db path : %@", dbPath);
    } else {
        //error
        NSLog(@"search Document path error. database file open error.");
        return false;
    }

    //DBファイルがDocument配下に存在するか判定
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        //存在しない
        //デフォルトのDBファイルをコピー(初回のみ)
        //ファイルはアプリケーションディレクトリ配下に格納されている。
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* orgPath = [bundle bundlePath];
        //初期ファイルのパス。(~/XXX.app/sample.db)
        orgPath = [orgPath stringByAppendingPathComponent:DB_FILE];
        //        NSLog(@"db file copy : %@ to %@.", orgPath, dbPath);
        //デフォルトのDBファイルをDocument配下へコピー
        NSError* e = [[NSError alloc] init];
        if (![fileManager copyItemAtPath:orgPath toPath:dbPath error:&e]) {
            //error
            NSLog(@"db file copy error. : %@ to %@.", orgPath, dbPath);
            NSLog(@"ファイルのコピーに失敗：%@", e.description);
            return false;
        }
    }
    _db = [FMDatabase databaseWithPath:dbPath];
    return [_db open];
}

/**
 *  DBクローズ
 */
-(void)closeDatabase{
    NSLog(@"closeDatabase");
    if (_db) {
        [_db close];
    }
}

-(void)setResponseResult:(NSDictionary*)response {
    NSDictionary* header = [response objectForKey:@"header"];
    NSDictionary* value = [response objectForKey:@"value"];
    
    if (header != nil || header.count > 0) {
        
    }
    
    if (value != nil || value.count > 0) {
        
    }
}

- (NSArray*)selectAllItem:(NSString*)sql
{
    NSMutableArray* results = [[NSMutableArray alloc] init];

    if (![_db open]) {
        NSLog(@"%@", @"open error");
    }

    FMResultSet* rs = [_db executeQuery:sql];
    while ([rs next]) {
        NSDictionary* dic = [rs resultDictionary];
        [results addObject:dic];
    }

    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }

    [rs close];
    if (![_db close]) {
        NSLog(@"%@", @"close error");
    }
    return results;
}

- (void)insertItem:(NSArray*)items tableName:(NSString*)name
{

    NSString* sql = nil;
    NSMutableArray* arraySQL = [[NSMutableArray alloc] init];

    //PORT_MASTER
    if ([name isEqualToString:@"PORT_MASTER"]) {
        for (NSDictionary* item in items) {
            sql = [[NSString alloc] initWithFormat:@"INSERT INTO PORT_MASTER (port_id,name,via_type,sort_no) VALUES (%@, '%@', %@, %@) ",
                                                   [item objectForKey:@"port_id"],
                                                   [item objectForKey:@"name"],
                                                   @"0",
                                                   [item objectForKey:@"sort_no"]];
            [arraySQL addObject:sql];
        }
    }

    for (NSString* sql in arraySQL) {
        [_db executeUpdate:sql];
    }
}

- (NSArray*)selectPORT_MASTER
{
    NSString* sql = @"select"
                     "*"
                     "from PORT_MASTER"
                     "order by sort_no";


    FMResultSet* rs = [_db executeQuery:sql];

    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }

    return [self getPORT_MASTER:rs];
}

- (NSArray*)getPORT_MASTER:(FMResultSet*)rs
{
    NSMutableArray* dataArray = [NSMutableArray array];

//    while ([rs next]) {
//        PORT_MASTER* portMaster = [[PORT_MASTER alloc] init];
//        for (int i = 0; i < [rs columnCount]; i++) {
//            [portMaster setValue:[rs objectForColumnIndex:i]
//                          forKey:[rs columnNameForIndex:i]];
//        }
//        [dataArray addObject:portMaster];
//    }
//    [rs close];
    return dataArray;
}

- (NSArray*)selectRUN_STATUS:(NSString*)company_id
{
    NSString* sql = @
    "select "
    "* "
    "from RUN_STATUS "
    "where run_id = ? and company_id = ? "
    "order by sort_no ";
    
    NSString* run_id = [UtilityController run_id];
    
    //取得処理実行
    FMResultSet* rs = [_db executeQuery:sql,run_id,company_id];
    
    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    NSMutableArray* dataArray = [NSMutableArray array];
    

    while ([rs next]) {
        RUN_STATUS* runStatus = [[RUN_STATUS alloc] init];
                for (int i = 0; i < [rs columnCount]; i++) {
            [runStatus setValue:[rs objectForColumnIndex:i]
                         forKey:[rs columnNameForIndex:i]];
        }

        [dataArray addObject:runStatus];
    }
    [rs close];
    return dataArray;
}

- (NSArray*)getRUN_STATUS:(FMResultSet*)rs
{
    NSMutableArray* dataArray = [NSMutableArray array];
    
    while ([rs next]) {
        RUN_STATUS* runStatus = [[RUN_STATUS alloc] init];
        for (int i = 0; i < [rs columnCount]; i++) {

            [runStatus setValue:[rs objectForColumnIndex:i]
                          forKey:[rs columnNameForIndex:i]];
        }
        [dataArray addObject:runStatus];
    }
    [rs close];
    return dataArray;
}

/**
 *  RUN_STATUSテーブルから、当日run_id以外を削除（過去を削除）
 */
-(BOOL)deleteRUN_STATUS{
    NSString *sql = [NSString stringWithFormat:@"delete from RUN_STATUS where run_id != %@",[UtilityController run_id]];
    BOOL result = [_db executeUpdate:sql];
    return result;
}

/**
 *  運行ステータス更新
 *
 *  @param dic 登録値
 */
- (void)updateRUN_STATUS:(NSDictionary*)dic
{
    NSString* sql;
    
    if ([self checkRecordCount:dic] > 0)
    {
        //上書き登録
        sql = @
            "update RUN_STATUS "
            "  set status = ?, "
            "  updateDate = datetime('now', 'localtime')"
            "where "
            "    run_id = ? "
            "and company_id = ? "
            "and port_id_start = ? "
            "and port_id_end = ? ";
        
        [_db executeUpdate:sql,
         [dic objectForKey:@"status"],
         [dic objectForKey:@"run_id"],
         [dic objectForKey:@"company_id"],
         [dic objectForKey:@"port_id_start"],
         [dic objectForKey:@"port_id_end"]];
    }
    else {
        //新規登録
        sql = @
            "insert into RUN_STATUS ("
            " run_id, "
            " company_id, "
            " port_id_start, "
            " port_id_end, "
            " status, "
            " sort_no, "
            " createDate, "
            " updateDate "
            ") values ("
            " ?, "
            " ?, "
            " ?, "
            " ?, "
            " ?, "
            " ?, "
            " datetime('now', 'localtime'), "
            " datetime('now', 'localtime') "
            ")";

        [_db executeUpdate:sql,
         [dic objectForKey:@"run_id"],
         [dic objectForKey:@"company_id"],
         [dic objectForKey:@"port_id_start"],
         [dic objectForKey:@"port_id_end"],
         [dic objectForKey:@"status"],
         [dic objectForKey:@"sort_no"]];
    }
    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
}

/**
 *  RUN_STATUSの件数
 *
 *  @param dic RUN_STATUS条件
 */
- (int)checkRecordCount:(NSDictionary*)dic
{
    NSString* sql;
    sql = [[NSString alloc] initWithFormat:@
           "select count(*) count from RUN_STATUS "
           "where "
           "    run_id = %@ "
           "and company_id = %@ "
           "and port_id_start = %@ "
           "and port_id_end = %@ "
           "order by sort_no ",
           [dic objectForKey:@"run_id"],
           [dic objectForKey:@"company_id"],
           [dic objectForKey:@"port_id_start"],
           [dic objectForKey:@"port_id_end"]];
    
    int count = 0;
    
    //取得処理実行
    FMResultSet* rs = [_db executeQuery:sql];
    while([rs next]){
        count = [[rs stringForColumn:@"count"] intValue];
    }
    [rs close];
    return count;
}

@end