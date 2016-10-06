//
//  HelpViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "HelpViewController.h"
#import "InternetTool.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:[InternetTool createUrl:@"help"]];
    [_helpWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}
@end
