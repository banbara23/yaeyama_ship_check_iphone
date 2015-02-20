//
//  AneiStatusViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/05.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "AneiStatusViewController.h"
#import "AneiParser.h"
#import "AneiStatus.h"
#import "MBProgressHUD.h"
#import "AneiStatusDetailViewController.h"
#import "EnumPortType.h"
#import "EnumCssClassType.h"
#import "Status.h"

@interface AneiStatusViewController ()
{
    MBProgressHUD *progress;
    UIWindow *window;
    AneiStatus *anei;
}
@end

@implementation AneiStatusViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIRefreshControl初期処理
    [self initRefreshControl];
    
    //インジケータ初期設定
    [self initProgress];
    
    //起動時に全てのステータスを登録
    [self updateStatus];
}

- (void)initRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    // 更新アクションを設定
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // UITableViewControllerにUIRefreshControlを設定
    self.refreshControl = refreshControl;
}

//下に引っ張ると更新開始
- (void)onRefresh:(id)sender
{
    // 更新開始
    [self.refreshControl beginRefreshing];
    
    // 更新処理
    [self updateStatus];
    
    // 更新終了
    [self.refreshControl endRefreshing];
}

-(void)initProgress
{
    //MBProgressHUD インジケーター準備
    window = [[[UIApplication sharedApplication] windows] lastObject];
    
    //MBProgressHUD
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
}

-(void)updateStatus
{
    //回線チェック
    if ([Utils isNetworkEnabled]) {
        [Utils showAlaertView:@"ネットワークに接続できません"];
        return;
    }
    //インジケータ表示開始
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //テーブルデータ作成
        [self loadTableData];
        
        //インジケータ表示終了
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!anei || [Utils isEmptyMutableArray:anei.statusArray]) {
            [Utils showAlaertView:@"データ取得に失敗しました"];
            return;
        }
        [_tableView reloadData];
    });
}

//テーブルデータ取得
-(void)loadTableData
{
    AneiParser *aneiParser = [[AneiParser alloc]init];
    anei = [aneiParser getPasrsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([Utils isEmptyMutableArray:anei.statusArray]) {
        return 0;
    }
    return [anei.statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *port = (UILabel*)[cell viewWithTag:1];      //港名
    UILabel *comment = (UILabel*)[cell viewWithTag:2];    //運航状況
    [comment setAdjustsFontSizeToFitWidth:YES];
    [comment setMinimumFontSize:10];    //最小フォントサイズ
    
    Status *status = [anei.statusArray objectAtIndex:indexPath.row];
    
    //通常運航なら文字色が青、違ったら赤
    comment.textColor = [Utils getCommentTextColor:status.cssClassType];
    port.text = [self replaceEmBrackets:status.portName];
    comment.text = status.comment;
    
    return cell;
}

-(NSString*)replaceEmBrackets:(NSString*)str
{
    NSString *replaceString = str;
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    return replaceString;
}

//各セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([Utils isEmpty:anei.groupTitle]) {
        [Utils getTodayString:@"yyyy/MM/dd"];
    }
    return anei.groupTitle;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        Status *status = [anei.statusArray objectAtIndex:indexPath.row];
        AneiStatusDetailViewController *aneiStatusViewController = [segue destinationViewController];
        aneiStatusViewController.status = status;
//        [self.navigationController pushViewController:aneiStatusViewController animated:YES];
    }
}

//このメソッドがないとビルド時にwarningが出る
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//更新ボタン押下処理
-(IBAction)pushRefreshButton:(id)sender
{
    [self updateStatus];
    [_tableView reloadData];
}
@end
