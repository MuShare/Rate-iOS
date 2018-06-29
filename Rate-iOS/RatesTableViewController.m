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
#import "AlertTool.h"
#import "DaoManager.h"
#import <MJRefresh/MJRefresh.h>
#import "UIImageView+Extension.h"

@interface RatesTableViewController ()

@end

@implementation RatesTableViewController {
    AppDelegate *delegate;
    AFHTTPSessionManager *manager;
    UserTool *user;
    DaoManager *dao;
    NSDictionary *rates;
    Currency *selectedCurrency;
    NSNumber *selectedRate;
    NSNumber *favorite;

    //Search Bar
    UIView *searchBarView;
    UIView *disableViewOverlay;
    UISearchBar *searchBar;
    
    //Tip Mask
    UIView *maskView;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    user = [[UserTool alloc] init];
    if (!user.basicCurrencyTipShown) {
        [self showTipMask];
        user.basicCurrencyTipShown = YES;
    }
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    manager = [InternetTool getSessionManager];
    dao = [[DaoManager alloc] init];
    if (user.token != nil) {
        favorite = user.showFavorites? [NSNumber numberWithBool:YES]: nil;
    }
    
    //Load based currency from NSUserDefaults
    _basedCurrency = [dao.currencyDao getByCid:user.basedCurrencyId];
    
    _fetchedResultsController.delegate = self;
    
    //Bind MJRefresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshRates];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //Set up search bar
    [self setupSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Reset base currency name.
    [self.navigationItem.leftBarButtonItem setTitle:_basedCurrency.name];
    _basedCurrencyImageView.image = [UIImage imageNamed:_basedCurrency.code];
    _basedCurrencyCodeLabel.text = _basedCurrency.code;
    _basedCurrencyNameLabel.text = _basedCurrency.name;
    
    //Reload rates values if showFavorite is changed.
    if (delegate.refreshRates) {
        delegate.refreshRates = NO;
        favorite = user.showFavorites? [NSNumber numberWithBool:YES]: nil;
        user = [[UserTool alloc] init];
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideSearchBar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [_fetchedResultsController.sections[0] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rateIdentifier"
                                                                               forIndexPath:indexPath];
    UIImageView *currencyImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *rateLabel = (UILabel *)[cell viewWithTag:4];
    
    currencyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", currency.code]];
    codeLabel.text = currency.code;
    nameLabel.text = currency.name;
    rateLabel.text = [NSString stringWithFormat:@"%.4f", [rates[currency.cid] floatValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    selectedCurrency = [_fetchedResultsController objectAtIndexPath:indexPath];
    selectedRate = rates[selectedCurrency.cid];
    [self performSegueWithIdentifier:@"rateSegue" sender:self];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([searchText length] == 0) {
        [self filterResultsToOriginal];
        [self searchBar:searchBar activate:YES];
    }
    else {
        _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:favorite
                                                                                Without:user.basedCurrencyId
                                                                            withKeyword:searchText];
        [self.tableView reloadData];
        [self searchBar:searchBar activate:NO];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideSearchBar];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([segue.identifier isEqualToString:@"selectBaseSegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        //Tell Currencies Controller what attribute to set.
        [segue.destinationViewController setValue:@"basedCurrency" forKey:@"currencyAttributeName"];
    } else if ([segue.identifier isEqualToString:@"rateSegue"]) {
        //set to currency for RateViewController
        [segue.destinationViewController setValue:selectedCurrency forKey:@"toCurrency"];
        [segue.destinationViewController setValue:selectedRate forKey:@"rate"];
    }
}

#pragma mark - Action
- (IBAction)searchCurrency:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         searchBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, [self topPadding] + 44.0);
                         [self searchBar:searchBar activate:YES];
                         [searchBar becomeFirstResponder];
                     }
                     completion:nil];
}

- (IBAction)changeBaseCurrency:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self performSegueWithIdentifier:@"selectBaseSegue" sender:self];
}

#pragma mark - Service

- (void)refreshRates {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_basedCurrency.cid forKey:@"from"];
    
    if (user.token != nil) {
        [parameters setObject:[NSNumber numberWithBool:user.showFavorites] forKey:@"favorite"];
    }
    [manager GET:[InternetTool createUrl:@"api/rate/current"]
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
             if ([response statusOK]) {
                 rates = [[response getResponseResult] objectForKey:@"rates"];
                 
                 //Refresh favorite currencies stored in local database if user logined.
                 if (user.token != nil) {
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
                 _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:favorite
                                                                                         Without:user.basedCurrencyId
                                                                                     withKeyword:nil];
                 [self.tableView reloadData];
                 [self.tableView.mj_header endRefreshing];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (DEBUG) {
                 NSLog(@"Server error: %@", error.localizedDescription);
             }
             [self.tableView.mj_header endRefreshing];
             InternetResponse *response = [[InternetResponse alloc] initWithError:error];
             switch ([response errorCode]) {
                 case ErrorCodeNotConnectedToInternet:
                     [AlertTool showNotConnectInternet:self];
                     break;
                 default:
                     break;
             }
         }];
    
}

- (CGFloat)topPadding {
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        topPadding = window.safeAreaInsets.top;
    }
    if (topPadding == 0) {
        topPadding = 20.0;
    }
    return topPadding;
}

- (void)setupSearchBar {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CGFloat topPadding = [self topPadding];
    searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, - (topPadding + 41.0), self.view.frame.size.width, topPadding + 41.0)];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, topPadding, self.view.frame.size.width - topPadding, 44.0)];
    
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBarView.backgroundColor = [UIColor colorWithRed:38.0 / 255.0 green:186.0 / 255.0 blue:152.0 / 255.0 alpha:1.0];
    searchBar.tintColor = [UIColor whiteColor];
    //Set text to white
    UITextField *searchTextField = [searchBar valueForKey:@"searchField"];
    searchTextField.textColor = [UIColor whiteColor];
    searchTextField.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = (UIImageView *)searchTextField.leftView;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [UIColor whiteColor];
    UIButton *clearButton = (UIButton *)[searchTextField valueForKey:@"clearButton"];
    [clearButton setImage:[clearButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    clearButton.tintColor = [UIColor whiteColor];
    searchBar.showsCancelButton = YES;
    
    [searchBarView addSubview:searchBar];
    
    disableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    disableViewOverlay.backgroundColor = [UIColor blackColor];
    disableViewOverlay.alpha = 0;
    disableViewOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    disableViewOverlay.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.navigationController.view addSubview:searchBarView];
}

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL)active {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    self.tableView.allowsSelection = !active;
    self.tableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];
    } else {
        disableViewOverlay.alpha = 0;
        [self.view addSubview:disableViewOverlay];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear animations:^{
                                disableViewOverlay.alpha = 0.6;
                            }
                         completion:nil];
    }
}

- (void)hideSearchBar {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat height = [self topPadding] + 44.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         searchBar.text = @"";
                         [self filterResultsToOriginal];
                         searchBarView.frame = CGRectMake(0, - height, self.view.frame.size.width, height);
                         [self searchBar:searchBar activate:NO];
                         [searchBar resignFirstResponder];
                     }
                     completion:nil];
}

- (void)filterResultsToOriginal {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:favorite
                                                                            Without:user.basedCurrencyId
                                                                        withKeyword:nil];
    [self.tableView reloadData];
}

- (void)showTipMask {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CGFloat height = [self topPadding] + 44.0;
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height)];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    //Create guide arrow.
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 90, 90)];
    arrowImageView.image = [UIImage imageNamed:@"guide_arrow"];
    [maskView addSubview:arrowImageView];
    //Create guide tip.
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    tipLabel.text = NSLocalizedString(@"base_currency_tip", @"Click to set base currency.");
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [maskView addSubview:tipLabel];
    //Create dismiss button
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 80, 140, 160, 40)];
    [dismissButton setTitle:NSLocalizedString(@"i_know", @"I know") forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 5.0;
    dismissButton.layer.borderWidth = 1.0;
    dismissButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [dismissButton addTarget:self action:@selector(dismissTipMask:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:dismissButton];
    [self.tabBarController.view addSubview:maskView];
}

- (void)dismissTipMask:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [maskView removeFromSuperview];
}

@end
