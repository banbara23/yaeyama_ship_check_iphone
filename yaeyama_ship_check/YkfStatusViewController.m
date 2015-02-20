//
//  YkfStatusViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/05.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "YkfStatusViewController.h"
#import "YkfParser.h"
#import "MBProgressHUD.h"
#import "ykfStatus.h"
#import "Status.h"
#import "EnumCssClassType.h"
#import "EnumPortType.h"

@interface YkfStatusViewController ()
{
    MBProgressHUD *progress;
    UIWindow *window;
    YkfStatus *ykf;
}
@end

@implementation YkfStatusViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RefreshControll初期処理
    [self initRefreshControl];
    
    //インジケータ初期設定
    [self initProgress];
    
    //起動時に全てのステータスを登録
    [self updateStatus];
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
        
        if (!ykf || [Utils isEmptyMutableArray:ykf.statusArray]) {
            [Utils showAlaertView:@"データ取得に失敗しました"];
            return;
        }
        [_tableView reloadData];
    });
}

//インジケーター表示
-(void)showIndicator {
    [progress show:YES];
}

//インジケーター非表示
-(void)hideIndicator {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//テーブルデータ取得
-(void)loadTableData
{
    ykf = [[YkfStatus alloc]init];
    YkfParser *ykfParser = [[YkfParser alloc]init];
    ykf = [ykfParser getParsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([Utils isEmptyMutableArray:ykf.statusArray]) {
        return 0;
    }
    return ykf.statusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *port = (UILabel*)[cell viewWithTag:1];      //港名
    UILabel *comment = (UILabel*)[cell viewWithTag:2];    //運航状況
    
    Status *status = [ykf.statusArray objectAtIndex:indexPath.row];

    //通常運航なら文字色が青、違ったら赤
    comment.textColor = [Utils getCommentTextColor:status.cssClassType];
    port.text = status.portName;
    comment.text = status.comment;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([Utils isEmpty:ykf.groupTitle]) {
        [Utils getTodayString:@"yyyy/MM/dd"];
    }
    return ykf.groupTitle;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
