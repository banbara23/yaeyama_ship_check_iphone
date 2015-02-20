//
//  AneiStatusViewController.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/05.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AneiParser.h"

@interface AneiStatusViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UILabel *portLabel;
//@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
-(IBAction)pushRefreshButton:(id)sender;
@end
