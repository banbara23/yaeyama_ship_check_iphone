//
//  AneiWebViewController.m
//  yaeyama_ship_check
//
//  Created by banbaraniisan on 2015/02/07.
//  Copyright (c) 2015年 ikemura. All rights reserved.
//

#import "AneiWebViewController.h"
#import "Consts.h"

@implementation AneiWebViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _webView.delegate = self;
    [self updateBtnEnabled];
    [self loadURL];
}

//ボタンの有効無効を設定
- (void)updateBtnEnabled {
    _backBtn.enabled = _webView.canGoBack;
    _forwardBtn.enabled = _webView.canGoForward;
    _stopBtn.enabled = _webView.loading;
    _refleshBtn.enabled = !_webView.loading;
}

- (void)loadURL {
    
    NSURL *url = [NSURL URLWithString:ANEI_WEB_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (IBAction)tapBackBtn:(id)sender {
    [_webView goBack];
}

- (IBAction)tapforwardBtn:(id)sender {
    [_webView goForward];
}

- (IBAction)tapRefleshBtn:(id)sender {
    [_webView reload];
}

- (IBAction)tapStopBtn:(id)sender {
    [_webView stopLoading];
}

/**
 * Webページのロード時にインジケータを動かす
 */
- (void)webViewDidStartLoad:(UIWebView*)webView
{
    [self updateBtnEnabled];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


/**
 * Webページのロード完了時にインジケータを非表示にする
 */
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self updateBtnEnabled];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
