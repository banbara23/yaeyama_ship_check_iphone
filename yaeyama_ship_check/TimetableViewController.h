//
//  TimetableViewController.h
//  航路お知らせ
//
//  Created by 池村　和剛 on 2014/05/21.
//  Copyright (c) 2014年 池村　和剛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimetableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    @public NSDictionary *dicSelect;
}
@property (weak, nonatomic) IBOutlet UITableView *tblTimetable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
- (IBAction)sgmCategoryPush:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblDown;
@property (weak, nonatomic) IBOutlet UILabel *lblUp;


@property NSDictionary *dicSelect;

@end
