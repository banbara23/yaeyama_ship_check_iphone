//
//  TimetableViewController.m
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/21.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import "TimetableViewController.h"

@interface TimetableViewController () {
    NSArray *result;
}

@end

@implementation TimetableViewController
@synthesize dicSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tblTimetable.delegate = self;
    _tblTimetable.dataSource = self;
    
    //ios 7 のUITableView で、一番上のスペースを消す
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [NSString stringWithFormat:@"%@航路", [dicSelect objectForKey:@"name"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


///TableViewのセクションの数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//1つのセクションに含まれるrowの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [result count];
    return 10;
}

//1つ1つのセルを返す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    _lblDown.text = @"down";
    _lblUp.text = @"up";

    return cell;
}

//セルがタップされたイベントをキャッチする
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // cellがタップされた際の処理
//}

/**
 *  セグメント変更
 *
 *  @param sender 変更情報
 */
- (IBAction)sgmCategoryPush:(id)sender {
    
//    _lblCompany.text = [UtilityController getCompanyName:(int)_sgmCategory.selectedSegmentIndex];

    [_tblTimetable reloadData];
}
@end
