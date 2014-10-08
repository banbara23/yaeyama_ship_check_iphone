//
//  StatusViewController.m
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/15.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "StatusViewController.h"
#import "RUN_STATUS.h"
#import "AFHTTPRequestOperationManager.h"
#import "ResponseResult.h"
#import "UserDefaultsManager.h"
#import "ANNEI.h"

@interface StatusViewController ()
{
    DBManager *db;
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
const int SINGLE_GET_MODE = 3;

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
    db = [DBManager sharedInstance];
    
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
    return [result count];
}

//1つ1つのセルを返す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //resut[行番号]を取得して表示する
    RUN_STATUS *runStatus = [result objectAtIndex:indexPath.row];
//    NSLog(@"row %@",indexPath.row);
    
    UILabel *lblPort = (UILabel*)[cell viewWithTag:1];      //港名
    UILabel *lblStatus = (UILabel*)[cell viewWithTag:2];    //運航状況
    NSArray *value;

    switch (requestMode) {
        case ALL_GET_MODE:
            value = [ANNEI getValue];
            break;
            
        case ANNEI_MODE:
            
            break;
            
        case YKF_MODE:
            
            break;
            
        case DREAM_MODE:
            
            break;
    }
    
    //港名
    NSString *endName = [UtilityController getPortIdName:runStatus.port_id_end];
    lblPort.text = endName;
    
    //ラベルに運航状況を設定
    lblStatus.text = [UtilityController getStatusName:runStatus.status];
    switch (runStatus.status) {
        case 1:     //運航    青
            lblStatus.textColor = [UIColor blueColor];
            break;
            
        case 2:     //欠航    赤
            lblStatus.textColor = [UIColor redColor];
            break;
            
        default:    //未定 & 不明    グレー
            lblStatus.textColor = [UIColor grayColor];
            break;
    }
    
    return cell;
}

#pragma mark - イベント
/**
 *  セグメント変更イベント
 */
- (IBAction)scCompanyChange:(id)sender {
    //会社名の設定
    [self setCampanyName];
    
    //一覧の再作成
    [self selectRUN_STATUS];
//    [_tblStatus reloadData];
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
    [self selectRUN_STATUS];    //DBから一覧を変数を取得
//    [_tblStatus reloadData];    //テーブルリロード
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

/**
 *  運航状況テーブルから一覧を取得
 */
-(void)selectRUN_STATUS {
    
//    NSString *company_id = [NSString stringWithFormat:@"%ld", (long)_scCompany.selectedSegmentIndex];
//    result = [db selectRUN_STATUS:company_id];
    [_tblStatus reloadData];
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
    
    requestMode = ALL_GET_MODE;
    
    //インジケータ表示開始
    [self showIndicator];
    
    //安栄
//    [self runCheckAnnei];
    
    //八重山観光
//    [self runCheckYKF];
    
    //ドリーム
    [self runCheckDream];
    
        
    //DBから一覧を読み込む
    _company_id = 0;
    [self selectRUN_STATUS];
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
    [self AFRequest:1];
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
          [self setResult:responseObject];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self showError];
          NSLog(@"Error: %@", error);
      }];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return nil;
}

//結果保存
-(void)setResult:(NSDictionary*)resultObject {
    NSString* name = [resultObject objectForKey:@"name"];
    NSDictionary* results = [resultObject objectForKey:@"results"];
    
    NSLog(@"%@ 取得",name);
    NSLog(@"%@",results);
    
    //保存
    [UserDefaultsManager save:results saveKey:name];
    
    //処理完了チェック
    if([self isHideIndicator:name]) {
        [self hideIndicator];
        [_tblStatus reloadData];
    }

//    if ([@"anei" isEqual:name]) {
//        responseResult.dicAnnei = results;
//    }
//    else if ([@"ykf" isEqual:name]) {
//        responseResult.dicYkf = results;
//    }
//    else if ([@"dream" isEqual:name]) {
//        responseResult.dicDream = results;
//    }

}

-(void)showError {
    [self hideIndicator];
    [self showAlaertView:@"Json取得失敗"];
}

-(bool)isHideIndicator:(NSString*)name {

    [UserDefaultsManager exist:name];
    
    switch (requestMode) {
        case SINGLE_GET_MODE:
            if ([UserDefaultsManager exist:name]) {
                return true;
            }
            break;
            
        case ALL_GET_MODE:
            if ([UserDefaultsManager exist:@"anei"] &&
                [UserDefaultsManager exist:@"ykf"] &&
                [UserDefaultsManager exist:@"dream"]) {
                return true;
            }
            break;
    }
    return false;
}

@end
