//
//  StatusViewController.m
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/15.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "StatusViewController.h"
#import "RUN_STATUS.h"
//#import "NSString+HTML.h"
//#import "ParsContoller.h"
#import "AFHTTPRequestOperationManager.h"
#import "ResponseResult.h"
#import "UserDefaultsManager.h"

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
    
    //インジケータ初期設定
    [self initProgress];
    
    //起動時に全てのステータスを登録
    [self setStatusFirst];
    
    self.title = [NSString stringWithFormat:@"%@の運航状況",[UtilityController getToday]];
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
    if (requestMode == ALL_GET_MODE) {
        //安栄を表示させる
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
    //一覧の再作成
    [self selectRUN_STATUS];
//    [_tblStatus reloadData];
}

/**
 *  更新ボタンプ押下イベント
 */
- (IBAction)btnRefreshPush:(id)sender {
    
    //０〜６時に更新ボタンを押下した場合、アラートメッセージを表示して処理を中断する
//    if ([self waiteTime]) {
//        NSString *msg = [NSString stringWithFormat:@"0〜%d時は運航状況が取得できないため、%d時以降に再度更新してください",OPEN_HOUER,OPEN_HOUER];
//        //アラート表示
//        [self showAlaertView:msg];
//        return;
//    }
    
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
        [self refreshView];
        
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
    
    NSString *company_id = [NSString stringWithFormat:@"%ld", (long)_scCompany.selectedSegmentIndex];
    result = [db selectRUN_STATUS:company_id];
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
    //０〜６時に更新ボタンを押下した場合、アラートメッセージを表示して処理を中断する
//    if ([self waiteTime]) {
//        return;
//    }
    
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
    [self runCheckYKF];
    
    //ドリーム
//    [self runCheckDream];
    
        
    //DBから一覧を読み込む
    _company_id = 0;
    [self selectRUN_STATUS];
}

#pragma mark 安栄

/**
 *  安栄　運行判断
 *  @return true：通常運行　false：欠航
 */
- (void)runCheckAnnei{
    
    [self AFRequest:0];
    
//    ParsContoller *pars = [[ParsContoller alloc] init];
//    NSMutableArray *array = [pars htmlParsAnei];
//    if ([array count] < 1) {
//        return;
//    }
//    for (NSDictionary *node in array) {
//        NSDictionary *dic = @{
//                              @"status"          :[self statusAnei:[node objectForKey:@"a"]],
//                              @"run_id"          :[UtilityController run_id],
//                              @"company_id"      :@"0",
//                              @"port_id_start"   :@"0",
//                              @"port_id_end"     :[UtilityController getPortId:[node objectForKey:@"h6"]],
//                              @"sort_no"         :[UtilityController getPortId:[node objectForKey:@"h6"]]
//                              };
//        //登録実行
//        [db updateRUN_STATUS:dic];
//    }
}

/**
 *  八重山観光フェリー　運行判断
 */
-(NSString*)createHtml:(NSString*)json
{
//    NSData *ndata = [json dataUsingEncoding: NSUTF16StringEncoding];
//    //取得したレスポンスをJSONパース
//    NSError *e = nil;
//    NSDictionary* dic = [NSJSONSerialization
//                           JSONObjectWithData:ndata
//                           options:kNilOptions
//                           error:&e];
//    
//    NSString *html = [[NSString alloc]initWithFormat:@
//                       "<html><head><title></title></head><body>%@</body></html>"
//                       ,[dic objectForKey:@"content"]];
//    //文字実体参照をMWFeedParserライブラリを利用して変換する
//    return [html stringByDecodingHTMLEntities];
    return nil;
 }

#pragma mark 八重山観光フェリー
/**
 *  八重山観光フェリー　運行判断
 例：竹富航路 ◯ 通常運航　という文字列がresultStringに格納されている
 */
-(void)runCheckYKF {
    [self AFRequest:1];
//    ParsContoller *pars = [[ParsContoller alloc] init];
//    NSMutableArray *array = [pars htmlParsYKF];
//    if ([array count] < 1) {
//        return;
//    }
//    for (NSDictionary *node in array) {
//        NSDictionary *dic = @{
//                              @"status"          :[self statusYKF:node],
//                              @"run_id"          :[UtilityController run_id],
//                              @"company_id"      :@"1",
//                              @"port_id_start"   :@"0",
//                              @"port_id_end"     :[UtilityController getPortId:[node objectForKey:@"port"]],
//                              @"sort_no"         :[UtilityController getPortId:[node objectForKey:@"port"]]
//                              };
//        //登録実行
//        [db updateRUN_STATUS:dic];
//    }
}

#pragma mark ドリーム

/**
 *  ドリーム　運行判断
 */
-(void)runCheckDream
{
    [self AFRequest:2];
//    ParsContoller *pars = [[ParsContoller alloc] init];
////    NSMutableArray *array = [pars htmlParsDream];
//    
//    NSString* url = @"http://www.ishigaki-dream.co.jp/m/";
//    _company_id = 2;
//    NSData *dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    NSString *string = [[NSString alloc] initWithData:dat encoding:NSShiftJISStringEncoding];
//    NSString *status = @"";
//    NSDictionary *dicPort = @{@"大原": @"1",
//                              @"鳩間上原": @"2",
//                              @"竹富": @"3",
//                              @"小浜": @"4",
//                              @"黒島": @"5",
//                              @"プレミアムドリーム":@"8",
//                              @"スーパードリーム":@"9"};
//    
//    for (NSString *name in dicPort) {
//        NSString *word1 = [name stringByAppendingString:@"…○"];
//        NSString *word2 = [name stringByAppendingString:@"…×"];
//        NSString *word3 = [name stringByAppendingString:@"…△"];
//        NSString *word4 = [name stringByAppendingString:@"…運休日"];
//        
//        if ([string rangeOfString:word1].location != NSNotFound) {      //港名…○
//            status = @"1";  //通常運航
//        }
//        else if ([string rangeOfString:word2].location != NSNotFound) { //港名…×
//            status = @"2";  //欠航
//        }
//        else if ([string rangeOfString:word3].location != NSNotFound) { //港名…△
//            status = @"3";  //未定
//        }
//        else if ([string rangeOfString:word4].location != NSNotFound) { //港名…運休日
//            status = @"4";  //運休日
//        }
//        else {
//            /*
//             スーパードリーム…石垣発大原行08：15　石垣発竹富行14：00
//             という表記があるため、上のifに引っかからなければ運航していると見なす
//             */
//            status = @"1";  //通常運航
//        }
//        
//        NSDictionary *param = @{
//                              @"status"          :status,
//                              @"run_id"          :[UtilityController run_id],
//                              @"company_id"      :@"2",
//                              @"port_id_start"   :@"0",
//                              @"port_id_end"     :[dicPort objectForKey:name],
//                              @"sort_no"         :[dicPort objectForKey:name]
//                              };
//        //登録実行
//        [db updateRUN_STATUS:param];
//    }
    [self hideIndicator];
}

/**
 *  運航ステータスを判別
 *  通常運航：１　それ以外：欠航
 */
- (NSString*)isRun:(NSString*)string {
    if ([string rangeOfString:@"通常運航"].location != NSNotFound) {
        return @"1";
    }
    return @"2";
}

/**
 *  運航ステータスを判別
 *  通常運航：１　それ以外：欠航
 */
- (NSString*)statusAnei:(NSString*)string {
    if ([string rangeOfString:@"通常運航"].location != NSNotFound) {
        return @"1";
    }
    else if([string rangeOfString:@"欠航有り"].location != NSNotFound) {
        return @"2";
    }
    else if([string rangeOfString:@"欠航"].location != NSNotFound) {
        return @"2";
    }
    else if([string rangeOfString:@"未定"].location != NSNotFound) {
        return @"3";
    }
    
    return @"0";
}

/**
 *  運航ステータスを判別
 *  通常運航：１　それ以外：欠航
 */
- (NSString*)statusYKF:(NSDictionary*)node {
    NSString *status = [node objectForKey:@"status"];
    NSString *comment = [node objectForKey:@"comment"];
    NSString *string;
    
    //タグが正常に記述されていないらしく、statusが空白の港がある（上原・鳩間）
    if ([status length] > 0) {
        string = status;
    }
    else {
        string = comment;
    }
    
    if ([string rangeOfString:@"◯"].location != NSNotFound) {
        return @"1";
    }
    else if ([string rangeOfString:@"○"].location != NSNotFound) {
        return @"1";
    }
    else if ([string rangeOfString:@"☓"].location != NSNotFound) {
        return @"2";
    }
    else if ([string rangeOfString:@"通常運航"].location != NSNotFound) {
        return @"1";
    }
    else if ([string rangeOfString:@"欠航"].location != NSNotFound) {
        return @"2";
    }
    else if ([comment rangeOfString:@"通常運航"].location != NSNotFound) {
        return @"1";
    }
    else if ([comment rangeOfString:@"欠航"].location != NSNotFound) {
        return @"2";
    }
    
    return @"0";
}

/**
 *  運航ステータスを判別
 *  通常運航：１　それ以外：欠航
 */
- (NSString*)statusDream:(NSString*)string {
    if ([string rangeOfString:@"通常運航"].location != NSNotFound) {
        return @"1";
    }
    else if ([string rangeOfString:@"運航"].location != NSNotFound) {
        return @"1";
    }
    else if([string rangeOfString:@"欠航"].location != NSNotFound) {
        return @"2";
    }
    
    return @"0";
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
