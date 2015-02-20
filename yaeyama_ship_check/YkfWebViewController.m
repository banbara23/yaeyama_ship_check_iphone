//
//  YkfWebViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/07.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "YkfWebViewController.h"
#import "Consts.h"

@implementation YkfWebViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadURL];
}

- (void)loadURL {
    NSURL *url = [NSURL URLWithString:YKF_WEB_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (IBAction)tapRefleshBtn:(id)sender {
    [_webView reload];
}

- (IBAction)tapBackBtn:(id)sender {
    [_webView goBack];
}

- (IBAction)tapForwardBtn:(id)sender {
    [_webView goForward];
}

- (IBAction)tapStopBtn:(id)sender {
    [_webView stopLoading];
}

@end
