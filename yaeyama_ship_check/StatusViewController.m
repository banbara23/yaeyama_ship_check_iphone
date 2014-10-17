//
//  StatusViewController.m
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/15.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "StatusViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ResponseResult.h"
#import "UserDefaultsManager.h"
#import "ParseManager.h"
#import "ANNEI.h"
#import "AneiConverter.h"

@interface StatusViewController ()
{
//    DBManager *db;
    MBProgressHUD *progress;
    ResponseResult *responseResult;
    
    NSArray *result;
    UIWindow *window;
    int _company_id;
    int requestMode;
}
@end

//運航状況の取得開始可能時間
const int OPEN_HOUER = 1;

//取得モード
const int ANNEI_MODE = 0;
const int YKF_MODE = 1;
const int DREAM_MODE = 2;
const int ALL_GET_MODE = 9;

static NSString * const kANEI = @"anei";
static NSString* const kYKF = @"ykf";
static NSString* const kDREAM = @"dream";

@implementation StatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 初期設定
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tblStatus.delegate = self;
    _tblStatus.dataSource = self;
    
    responseResult = [[ResponseResult alloc]init];
    
    //DBクラスのインスタンス化
//    db = [DBManager sharedInstance];
    
    //View初期設定
    [self initView];
    
    //ラベルに会社名を設定（初期値は安栄）
    [self setCampanyName];
    
    //インジケータ初期設定
    [self initProgress];
    
    //起動時に全てのステータスを登録
    [self setStatusFirst];
}

#pragma mark View初期設定
-(void)initView{
    //iOS6 ＆ 6.1対応
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //セグメントコントロールの文字サイズを調整
        [_scCompany
         setTitleTextAttributes:
         [NSDictionary dictionaryWithObject:[ UIFont boldSystemFontOfSize:14 ] forKey:UITextAttributeFont ]
         forState:UIControlStateNormal];
    }
    else {
        //ios 7 のUITableView で、一番上のスペースを消す
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark インジケータ初期設定
- (void) initProgress {
    //MBProgressHUD インジケーター準備
    window = [[[UIApplication sharedApplication] windows] lastObject];

    //MBProgressHUD
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
//    progress.delegate = self;
//    progress.dimBackground = YES;
}


#pragma mark - tblStatus

//TableViewのセクションの数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//1つのセクションに含まれるrowの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *convertData = [self getConvertData];
    NSArray *keys = [convertData allKeys];
    return [keys count];
}

//1つ1つのセルを返す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //resut[行番号]を取得して表示する
//    RUN_STATUS *runStatus = [result objectAtIndex:indexPath.row];
//    NSLog(@"row %@",indexPath.row);
    
    
    UILabel *lblPort = (UILabel*)[cell viewWithTag:1];      //港名
    UILabel *lblStatus = (UILabel*)[cell viewWithTag:2];    //運航状況
    NSDictionary *convertData = [self getConvertData];
    NSArray *keys = [convertData allKeys];
    lblPort.text = [keys objectAtIndex:indexPath.row];
    lblStatus.text = [convertData objectForKey:[keys objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSDictionary*)getConvertData {
    NSDictionary *convertData;
    switch (requestMode) {
        case ALL_GET_MODE:
            convertData = [ANNEI getValue];
            break;
            
        case ANNEI_MODE:
            convertData = [ANNEI getValue];
            break;
            
        case YKF_MODE:
            
            break;
            
        case DREAM_MODE:
            
            break;
    }
    return convertData;
}

#pragma mark - イベント
/**
 *  セグメント変更イベント
 */
- (IBAction)scCompanyChange:(id)sender {
    //会社名の設定
    [self setCampanyName];
    
    //一覧の再作成
//    [self selectRUN_STATUS];
}

/**
 *  更新ボタンプ押下イベント
 */
- (IBAction)btnRefreshPush:(id)sender {
    
    //回線状況をチェック
    if ([self checkNetStatus]) {
        NSString *msg = @"ネットワークに接続できません";
        //アラート表示
        [self showAlaertView:msg];
        return;
    }
    
    //インジケータ表示開始
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        //処理件数カウントをリセット
        _company_id = (int)_scCompany.selectedSegmentIndex;
    
        //テーブル再作成
//        [self setStatus];
        
        //画面更新
//        [self refreshView];
        
        //インジケータ表示終了
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

#pragma mark - Private Method

//テーブルの表示更新
-(void)refreshView {
//    [self selectRUN_STATUS];    //DBから一覧を変数を取得
}

//現在時間チェック
-(BOOL)waiteTime {
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSHourCalendarUnit fromDate:nowDate];

    //朝６時まではページが更新されておらず前日のままなので、取得しても無意味
    if (comps.hour < OPEN_HOUER) {
        return YES;
    }
    return NO;
}

//回線状況チェック
-(BOOL)checkNetStatus {
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            //インターネット接続出来ません
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

//アラート表示
-(void)showAlaertView:(NSString*)msg {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"お知らせ" message:msg
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
}

//インジケーター表示
-(void)showIndicator {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progress show:YES];
}

//インジケーター非表示
-(void)hideIndicator {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/*
 *  ステータス作成 初回のみ
 */
-(void)setStatusFirst
{
    
    //回線状況をチェック
    if ([self checkNetStatus]) {
        return;
    }
    
//    requestMode = ALL_GET_MODE;
    requestMode = ANNEI_MODE;
    
    //インジケータ表示開始
    [self showIndicator];
    
    //安栄
    [self runCheckAnnei];
    
    //八重山観光
//    [self runCheckYKF];
    
    //ドリーム
//    [self runCheckDream];
    
        
    //DBから一覧を読み込む
//    _company_id = 0;
//    [self selectRUN_STATUS];
}

/*
 *  会社名をラベルに設定
 */
- (void)setCampanyName {
    _lbCampany.text = [[UtilityController getCompanyName:_scCompany.selectedSegmentIndex] stringByAppendingString:@"の運行状況"];
}

/*
 *  更新日時をラベルに設定
 */
- (void)setUpdateTime{
    NSDate *date = [NSDate date];
    
    // 指定した書式で日付を文字列に変換する
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm:ss"];
    
    // 日付を yyyy/MM/dd hh:mm:ss形式に変更
    _lbUpdate.text = [dateFormatter stringFromDate:date];
}

#pragma mark 安栄

/**
 *  安栄　運行判断
 *  @return true：通常運行　false：欠航
 */
- (void)runCheckAnnei{
    [self AFRequest:0];
}


#pragma mark 八重山観光フェリー
/**
 *  八重山観光フェリー　運行判断
 例：竹富航路 ◯ 通常運航　という文字列がresultStringに格納されている
 */
-(void)runCheckYKF {
//    [self AFRequest:1];
    ParseManager* parse = [[ParseManager alloc] init];
    NSMutableArray *array = [parse htmlParsYKF];
    if ([array count] < 1) {
        return;
    }
    
}

#pragma mark ドリーム

/**
 *  ドリーム　運行判断
 */
-(void)runCheckDream
{
    [self AFRequest:2];
    [self hideIndicator];
}

//AFNetworkでの取得
-(NSDictionary*)AFRequest:(int)companyId {

    NSString *url = [UtilityController getKimonoURL:companyId];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [self convertResult:responseObject];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self showError];
          NSLog(@"Error: %@", error);
      }];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return nil;
}

//結果保存
-(void)convertResult:(NSDictionary*)resultObject {
    NSString* name = [resultObject objectForKey:@"name"];
    NSDictionary* results = [resultObject objectForKey:@"results"];
    
//    NSLog(@"%@ 取得",name);
//    NSLog(@"%@",results);
    
    if ([kANEI isEqual:name]) {
        AneiConverter *aneiConverter = [[AneiConverter alloc]initWithResult:results];
        [aneiConverter convert];
//        responseResult.dicAnnei = results;
    }
    else if ([kYKF isEqual:name]) {
//        responseResult.dicYkf = results;
    }
    else if ([kDREAM isEqual:name]) {
//        responseResult.dicDream = results;
    }
    
    //処理完了チェック
    if([self isRequestFinish]) {
        [self hideIndicator];
        [_tblStatus reloadData];
    }
}

-(void)showError {
    [self hideIndicator];
    [self showAlaertView:@"Json取得失敗"];
}

-(bool)isRequestFinish {
    
    switch (requestMode) {
        case ANNEI_MODE:
            if ([UserDefaultsManager exist:kANEI]) {
                return true;
            }
            break;
            
        case YKF_MODE:
            if ([UserDefaultsManager exist:kYKF]) {
                return true;
            }
            break;
            
        case DREAM_MODE:
            if ([UserDefaultsManager exist:kDREAM]) {
                return true;
            }
            break;
            
        case ALL_GET_MODE:
            if ([UserDefaultsManager exist:kANEI] &&
                [UserDefaultsManager exist:kYKF] &&
                [UserDefaultsManager exist:kDREAM]) {
                return true;
            }
            break;
    }
    return false;
}

@end
