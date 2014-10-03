//
//  StatusViewController.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/15.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblStatus;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scCompany;
- (IBAction)scCompanyChange:(id)sender;
- (IBAction)btnRefreshPush:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;


@end
