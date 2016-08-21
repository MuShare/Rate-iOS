//
//  RatesTableViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 7/31/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RatesTableViewController.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "DaoManager.h"
#import <SVGKit/SVGKit.h>
#import <MJRefresh/MJRefresh.h>

#import "MySearchResultsController.h"

@interface RatesTableViewController ()

@end

@implementation RatesTableViewController {
    AFHTTPSessionManager *manager;
    UserTool *user;
    DaoManager *dao;
    NSDictionary *rates;
    NSString *selectedCurrency;

}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
    
    //Load based currency from NSUserDefaults
    _basedCurrency = [dao.currencyDao getByCid:user.basedCurrencyId];
    
    _fetchedResultsController.delegate = self;
    
    //Bind MJRefresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshRates];
    }];
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Reset base currency name.
    [self.navigationItem.leftBarButtonItem setTitle:_basedCurrency.name];
    //Reload rates values.
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [_fetchedResultsController.sections[0] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rateIdentifier"
                                                                               forIndexPath:indexPath];
    SVGKFastImageView *currencyImageView = (SVGKFastImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *rateLabel = (UILabel *)[cell viewWithTag:4];
    
    currencyImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", currency.icon]];
    codeLabel.text = currency.code;
    nameLabel.text = currency.name;
    
    rateLabel.text = [NSString stringWithFormat:@"%.4f", [rates[currency.cid] floatValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    selectedCurrency = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"rateSegue" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if([segue.identifier isEqualToString:@"selectBaseSegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        //Tell Currencies Controller what attribute to set.
        [segue.destinationViewController setValue:@"basedCurrency" forKey:@"currencyAttributeName"];
    } else if([segue.identifier isEqualToString:@"rateSegue"]) {
        //set to currency for RateViewController
        [segue.destinationViewController setValue:selectedCurrency forKey:@"toCurrency"];
    }
}

#pragma mark - Service
- (void)refreshRates {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_basedCurrency.cid forKey:@"from"];
    
    if(user.token != nil) {
        [parameters setObject:[NSNumber numberWithInt:1] forKey:@"favorite"];
    }
    [manager GET:[InternetTool createUrl:@"api/rate/current"]
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
             if([response statusOK]) {
                 rates = [[response getResponseResult] objectForKey:@"rates"];
                 
                 //Refresh favorite currencies stored in local database if user logined.
                 if(user.token != nil) {
                     for(Currency *currency in [dao.currencyDao findAll]) {
                         currency.favorite = [NSNumber numberWithBool:NO];
                     }
                     for(NSString *cid in rates.allKeys) {
                         Currency *currency = [dao.currencyDao getByCid:cid];
                         currency.favorite = [NSNumber numberWithBool:YES];
                     }
                     [dao saveContext];
                 }
                 
                 //Reload data
                 _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:[NSNumber numberWithBool:user.token != nil]
                                                                                         Without:user.basedCurrencyId];
                 [self.tableView reloadData];
                 [self.tableView.mj_header endRefreshing];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if(DEBUG) {
                 NSLog(@"Server error: %@", error.localizedDescription);
             }
             [self.tableView.mj_header endRefreshing];
             InternetResponse *response = [[InternetResponse alloc] initWithError:error];
             switch ([response errorCode]) {

                 default:
                     break;
             }
         }];
    
}

#pragma mark - Action
- (IBAction)searchCurrency:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
}

- (IBAction)openSettingsMenu:(id)sender {
}
@end

