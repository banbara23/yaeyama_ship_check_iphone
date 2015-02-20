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
    [self loadURL];
}

- (void)loadURL {
    NSData *dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:ANEI_WEB_URL]];
    NSString *string = [[NSString alloc] initWithData:dat encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:ANEI_WEB_URL];
    [_webView loadHTMLString:string baseURL:url];
    
    // NSData型にNSStringから変換します。
//    NSData *dat2 = [string dataUsingEncoding:NSUTF8StringEncoding];
    // UIWebViewの以下メソッドを用いて、データを読み込ませます。
//    [_webView loadData:dat2 MIMEType:@"text/html"textEncodingName:@"utf-8"baseURL:nil];
    
//    NSURL *url = [NSURL URLWithString:ANEI_WEB_URL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:urlRequest];
}

- (IBAction)tapBackBtn:(id)sender {
    [_webView goBack];
}

- (IBAction)tapforwardBtn:(id)sender {
    [_webView goForward];
}

- (IBAction)tapRefleshBtn:(id)sender {
    [_webView reload];
//    [self loadURL];
}

- (IBAction)tapStopBtn:(id)sender {
    [_webView stopLoading];
}

@end
