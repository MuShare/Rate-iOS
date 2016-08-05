//
//  SubscribeTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "SubscriptionsTableViewController.h"
#import <SVGKit/SVGKit.h>

@interface SubscriptionsTableViewController ()

@end

@implementation SubscriptionsTableViewController

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subscribeIdentifer"];
    SVGKFastImageView *fromImageView = (SVGKFastImageView *)[cell viewWithTag:1];
    SVGKFastImageView *toImageView = (SVGKFastImageView *)[cell viewWithTag:2];
    fromImageView.image = [SVGKImage imageNamed:@"cn.svg"];
    toImageView.image = [SVGKImage imageNamed:@"us.svg"];
    return cell;
}

@end
