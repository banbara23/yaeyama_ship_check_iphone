//
//  ImpressionsViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/21.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "ImpressionsViewController.h"

@interface ImpressionsViewController ()

@end

@implementation ImpressionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL];
}

- (void)loadURL {
    NSURL *url = [NSURL URLWithString:IMPRESSIONS_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
