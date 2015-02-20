//
//  AppTopController.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/01/27.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTopController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UITableView *tableView ;
@end
