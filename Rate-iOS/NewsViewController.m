//
//  NewsViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 25/11/2016.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    self.title = [_content valueForKey:@"title"];
    NSString *cssFilePath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"css"];
    NSString *css = [NSString stringWithContentsOfFile:cssFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:@"<style>%@</style> %@", css, [_content valueForKey:@"html"]];
    [_contentWebView loadHTMLString:html baseURL:nil];
}

@end
