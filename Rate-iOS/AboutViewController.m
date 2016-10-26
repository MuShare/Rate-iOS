//
//  AboutViewController.m
//  Rate-iOS
//
//  Created by lidaye on 27/10/2016.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)rateInAppStore:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/rate-assistant-monitor-rate/id1139573801"]];
}
@end
