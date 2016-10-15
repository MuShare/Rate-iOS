//
//  CurrenciesTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "CurrenciesTableViewController.h"
#import "UserTool.h"
#import "InternetTool.h"
#import "AlertTool.h"

@interface CurrenciesTableViewController ()

@end

@implementation CurrenciesTableViewController {
    AppDelegate *delegate;
    UserTool *user;
    DaoManager *dao;
    AFHTTPSessionManager *manager;
    
    UIView *searchBarView;
    UIView *disableViewOverlay;
    UISearchBar *searchBar;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
    manager = [InternetTool getSessionManager];

    //Set fetchedResultsController
    _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:nil Without:nil withKeyword:nil];
    _fetchedResultsController.delegate = self;
    
    //Set up search bar
    [self setupSearchBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideSearchBar];
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
    
    return [_fetchedResultsController.sections[0] numberOfObjects]; //currencies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyIdentifer" forIndexPath:indexPath];
    
    UIImageView *currencyImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *favoriteButton = (UIButton *)[cell viewWithTag:4];
    
    currencyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", currency.icon]];
    codeLabel.text = currency.code;
    nameLabel.text = currency.name;

    //Set favorite button for logined user.
    if (user.token != nil) {
        favoriteButton.hidden = NO;
        [favoriteButton setImage:[UIImage imageNamed:currency.favorite.boolValue? @"currency_like": @"currency_unlike"]
                        forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_selectable) {
        Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath]; 
        //Save currency cid to sandbox.
        user.basedCurrencyId = currency.cid;
        delegate.refreshRates = YES;
        //Back to last view controller.
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        [controller setValue:currency forKey:_currencyAttributeName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    switch (type) {
        case NSFetchedResultsChangeUpdate:
            
            break;
            
        default:
            break;
    }
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
        _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:[NSNumber numberWithBool:NO]
                                                                                Without:nil
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

#pragma mark - Action
- (IBAction)selectShowType:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    switch ([sender selectedSegmentIndex]) {
        //Show all currencies
        case 0:
            _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:nil Without:nil withKeyword:nil];

            break;
        //Show favorites currencies
        case 1:
            //If your is unlogin, he should login at first.
            if (user.token == nil) {
                [self performSegueWithIdentifier:@"selectFavoriteUnloginSegue" sender:sender];
                return;
            } else {
                NSNumber *favorite = [NSNumber numberWithBool:YES];
                _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:favorite Without:nil withKeyword:nil];
                [self.tableView reloadData];
            }
            
            break;
        default:
            break;
    }
}

- (IBAction)setFavorite:(UIButton *)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    UIView *loadingView = [cell viewWithTag:5];
    loadingView.hidden = NO;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    [manager POST:[InternetTool createUrl:@"api/user/favorite"]
       parameters:@{
                    @"cid": currency.cid,
                    @"favorite": [NSNumber numberWithInt:!currency.favorite.boolValue]
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  //Save to database
                  currency.favorite = [NSNumber numberWithBool:!currency.favorite.boolValue];
                  [dao saveContext];
                  //Update UI
                  [sender setImage:[UIImage imageNamed:currency.favorite.boolValue? @"currency_like": @"currency_unlike"]
                          forState:UIControlStateNormal];
                  loadingView.hidden = YES;
                  
                  //Refresh rates in RatesTableViewController
                  delegate.refreshRates = YES;
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              loadingView.hidden = YES;
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

- (IBAction)searchCurrency:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         searchBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 61.0);
                         [self searchBar:searchBar activate:YES];
                         [searchBar becomeFirstResponder];
                     }
                     completion:nil];
}

#pragma mark - Service 
- (void)setupSearchBar {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, - 61.0, self.view.frame.size.width, 61.0)];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 20.0, self.view.frame.size.width - 20, 44.0)];
    
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
    } else{
        
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
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         searchBar.text = @"";
                         [self filterResultsToOriginal];
                         searchBarView.frame = CGRectMake(0, - 64.0, self.view.frame.size.width, 64.0);
                         [self searchBar:searchBar activate:NO];
                         [searchBar resignFirstResponder];
                     }
                     completion:nil];
}

- (void)filterResultsToOriginal {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:nil Without:nil withKeyword:nil];
    [self.tableView reloadData];
}

@end
