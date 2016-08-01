//
//  RatesTableViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 7/31/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RatesTableViewController.h"

@interface RatesTableViewController ()

@end

@implementation RatesTableViewController

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rateIdentifier"
                                                                               forIndexPath:indexPath];
    UIImageView *currencyImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *rateLabel = (UILabel *)[cell viewWithTag:3];
    currencyImageView.image = [UIImage imageNamed:@"USD"];
    codeLabel.text = @"USD";
    rateLabel.text = @"0.1678";
    return cell;
}

@end
