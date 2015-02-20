//
//  AneiStatusDetailViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "AneiStatusDetailViewController.h"
#import "EnumPortType.h"
#import "EnumPortType.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "AneiDetailParser.h"
#import "AneiDetailStatus.h"

@interface AneiStatusDetailViewController () {
    MBProgressHUD *progress;
    UIWindow *window;
    AneiDetailStatus *aneiDetailStatus;
}
@end

@implementation AneiStatusDetailViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RefreshControl初期処理
    [self initRefreshControl];
    
    //インジケータ初期設定
    [self initProgress];

    //起動時に全てのステータスを登録
    [self updateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if ([self isEmptyAneiDetailStatus]) {
            [Utils showAlaertView:@"データ取得に失敗しました"];
            return;
        }
        [_tableView reloadData];
    });
}

- (BOOL)isEmptyAneiDetailStatus {
    return !aneiDetailStatus
    || [Utils isEmptyMutableArray:aneiDetailStatus.aneiStatusFromIshigaki.statusArray]
    || [Utils isEmptyMutableArray:aneiDetailStatus.aneiStatusToIshigaki.statusArray];
}

//テーブルデータ取得
-(void)loadTableData
{
    AneiDetailParser *aneiDetailParser = [[AneiDetailParser alloc]init];
    aneiDetailStatus = [aneiDetailParser getPasrsData:[Utils getDetailUrl:_status.portType]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isEmptyAneiDetailStatus]) {
        return 0;
    }
    if (section == 0) {
        return aneiDetailStatus.aneiStatusFromIshigaki.statusArray.count;
    }
    else {
        return aneiDetailStatus.aneiStatusToIshigaki.statusArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *port = (UILabel*)[cell viewWithTag:1];      //港名
    UILabel *comment = (UILabel*)[cell viewWithTag:2];    //運航状況
    [comment setAdjustsFontSizeToFitWidth:YES];
//    [comment setMinimumFontSize:10];    //最小フォントサイズ
    Status *status;
    if (indexPath.section == 0) {
        status = [aneiDetailStatus.aneiStatusFromIshigaki.statusArray objectAtIndex:indexPath.row];
    }
    else {
        status = [aneiDetailStatus.aneiStatusToIshigaki.statusArray objectAtIndex:indexPath.row];
    }
    
    //通常運航なら文字色が青、違ったら赤
    comment.textColor = [Utils getCommentTextColor:status.cssClassType];
    port.text = status.portName;
    comment.text = status.comment;

    return cell;
}

//各セクションのタイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (aneiDetailStatus == nil) {
        return @"";
    }
    switch (section) {
        case 0:
            return aneiDetailStatus.aneiStatusFromIshigaki.groupTitle;
            break;
            
        case 1:
            return aneiDetailStatus.aneiStatusToIshigaki.groupTitle;;
            break;
    }
    return nil;
}

//このメソッドがないとビルド時にwarningが出る
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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

@end
