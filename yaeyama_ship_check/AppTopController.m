//
//  AppTopController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/01/27.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "AppTopController.h"
#import "OtherViewController.h"

@interface AppTopController ()
{
    NSArray *cellNames;
}
@end

@implementation AppTopController
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    cellNames = [NSArray arrayWithObjects:@"annei",@"ykf",nil];
    
    
    // initWithBarButtonSystemItemに、表示したいアイコンを指定します。
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:@"トップ"
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
    self.navigationItem.backBarButtonItem = btn;

}

#pragma mark - tblStatus

//TableViewのセクションの数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//1つのセクションに含まれるrowの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 1) {
        return 2;
    }
    return 1;
}

////1つ1つのセルを返す
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // "cell"というkeyでcellデータを取得
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    // cellデータが無い場合、UITableViewCellを生成して、"cell"というkeyでキャッシュする
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    if (indexPath.section < 1) {
//        cell.textLabel.text = [self getCellText:indexPath.row];
//    }
//    if (indexPath.section == 1){
//        cell.textLabel.text = @"当アプリについて";
//    }
//    return cell;
//}

- (NSString*)getCellText:(NSInteger) row
{
    switch (row) {
        case 0:
            return @"安栄観光";
            break;
        case 1:
            return @"八重山観光フェリー";
        default:
            return nil;
            break;
    }
    return nil;
}

//各セクションのタイトルを決定する
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch(section) {
//        case 0: // 1個目のセクションの場合
//            return @"ステータスのみ確認";
//            break;
//        case 1: // 2個目のセクションの場合
//            return @"webで確認";
//            break;
//        case 2: // 3個目のセクションの場合
//            return @"その他";
//            break;
//    }
//    return nil; //ビルド警告回避用
//}

/**
 *  テーブルのセルがタップされた時に呼ばれます。
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 */
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch(indexPath.section) {
//        case 0: // 1個目のセクションの場合
//            if (indexPath.row == 0) {
//                [self performSegueWithIdentifier:@"anei" sender:self];
//            }
//            else {
//                [self performSegueWithIdentifier:@"ykf" sender:self];
//            }
//            break;
//        case 1: // 2個目のセクションの場合
//            [self performSegueWithIdentifier:@"other" sender:self];
//            break;
//    }
//}

//- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
//    
//    // segue のidentifier で、どの画面遷移か判別する
//    if( [segue.identifier isEqualToString:@"statusSegue"] ) {
//        // 遷移先のUIViewControllerを指定
//        StatusViewController *svc = (StatusViewController*)[segue destinationViewController];
////        NextViewController* nvc = (NextViewController*)[segue destinationViewController];
//        [segue destinationViewController];
//        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
//        /* ここで遷移先画面にデータを渡したりする */
//    }
//    
//}

//このメソッドがないとビルド時にwarningが出る
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
