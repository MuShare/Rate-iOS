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

#pragma mark - Action
- (IBAction)shareNews:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"share_news", @"Share News")
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *safari = [UIAlertAction actionWithTitle:NSLocalizedString(@"open_on_safari", @"Open on Safari")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       NSURL *cleanURL = [NSURL URLWithString:[_content valueForKey:@"link"]];
                                                       [[UIApplication sharedApplication] openURL:cleanURL];
                                                   }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_name", @"Cancel")
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:safari];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
