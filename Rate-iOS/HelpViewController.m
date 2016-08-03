//
//  HelpViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:@"http://fczm.pw"];
    [_helpWebView loadRequest:[NSURLRequest requestWithURL:url]];
}


@end
