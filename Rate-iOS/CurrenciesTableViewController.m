//
//  CurrenciesTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "CurrenciesTableViewController.h"
#import "DaoManager.h"
#import "UserTool.h"
#import <SVGKit/SVGKit.h>

@interface CurrenciesTableViewController ()

@end

@implementation CurrenciesTableViewController {
    UserTool *user;
    DaoManager *dao;
    NSArray *currencies;
    Currency *selectedCurrency;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
    currencies = [dao.currencyDao findByLanguage:@"en"];
    [self.tableView reloadData];

}

#pragma mark - Table view data source
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
    return currencies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyIdentifer" forIndexPath:indexPath];
    Currency *currency = [currencies objectAtIndex:indexPath.row];
    SVGKFastImageView *currencyImageView = (SVGKFastImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *favoriteButton = (UIButton *)[cell viewWithTag:4];
    currencyImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", currency.icon]];
    codeLabel.text = currency.code;
    nameLabel.text = currency.name;
    [favoriteButton addTarget:self
                       action:@selector(favoriteButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    favoriteButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if(_selectable) {
        Currency *currency = [currencies objectAtIndex:indexPath.row];
        //Save currency cid to sandbox.
        user.basedCurrencyId = currency.cid;
        //Back to last view controller.
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [controller setValue:currency forKey:_currencyAttributeName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Action
- (void)favoriteButtonClicked:(UIButton *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Currency *currency = [currencies objectAtIndex:sender.tag];
    sender.highlighted = YES;
}
@end
