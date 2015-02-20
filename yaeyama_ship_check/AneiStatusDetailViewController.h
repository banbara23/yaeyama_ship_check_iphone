//
//  AneiStatusDetailViewController.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/11.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumPortType.h"
#import "Status.h"

@interface AneiStatusDetailViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property Status *status;

@end
