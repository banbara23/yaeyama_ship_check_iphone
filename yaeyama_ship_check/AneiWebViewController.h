//
//  AneiWebViewController.h
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/07.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AneiWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refleshBtn;

- (IBAction)tapBackBtn:(id)sender;
- (IBAction)tapforwardBtn:(id)sender;
- (IBAction)tapStopBtn:(id)sender;
- (IBAction)tapRefleshBtn:(id)sender;

@end
