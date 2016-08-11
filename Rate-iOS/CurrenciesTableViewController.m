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
#import <SVGKit/SVGKit.h>

@interface CurrenciesTableViewController ()

@end

@implementation CurrenciesTableViewController {
    UserTool *user;
    DaoManager *dao;
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
    manager = [InternetTool getSessionManager];

    //Set fetchedResultsController
    _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:nil Without:nil];
    _fetchedResultsController.delegate = self;
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
    NSLog(@"Currency %@, favorite = %@", currency.code, currency.favorite);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyIdentifer" forIndexPath:indexPath];
    
    SVGKFastImageView *currencyImageView = (SVGKFastImageView *)[cell viewWithTag:1];
    UILabel *codeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *favoriteButton = (UIButton *)[cell viewWithTag:4];
    
    currencyImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", currency.icon]];
    codeLabel.text = currency.code;
    nameLabel.text = currency.name;
//    [favoriteButton addTarget:self
//                       action:@selector(favoriteButtonClicked:)
//             forControlEvents:UIControlEventTouchUpInside];
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
        Currency *currency = [_fetchedResultsController objectAtIndexPath:indexPath]; //[currencies objectAtIndex:indexPath.row];
        //Save currency cid to sandbox.
        user.basedCurrencyId = currency.cid;
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

#pragma mark - Action
- (IBAction)selectShowType:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    switch ([sender selectedSegmentIndex]) {
        //Show all currencies
        case 0:
            _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:nil Without:nil];

            break;
        //Show favorites currencies
        case 1:
            //If your is unlogin, he should login at first.
            if (user.token == nil) {
                [self performSegueWithIdentifier:@"selectFavoriteUnloginSegue" sender:sender];
                return;
            } else {
                NSNumber *favorite = [NSNumber numberWithBool:YES];
                _fetchedResultsController = [dao.currencyDao fetchRequestControllerWithFavorite:favorite Without:nil];
                
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
    NSLog(@"Currency is %@, %@", currency.code, @{
                                              @"cid": currency.cid,
                                              @"favorite": [NSNumber numberWithInt:!currency.favorite.boolValue]
                                              });
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
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                      
                  default:
                      if (DEBUG) {
                          NSLog(@"Error code is %d", [response errorCode]);
                      }
                      loadingView.hidden = YES;
                      break;
              }
              NSLog(@"%d", [response errorCode]);
          }];

}


- (void)favoriteButtonClicked:(UIButton *)sender {
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
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {

                  default:
                      if (DEBUG) {
                          NSLog(@"Error code is %d", [response errorCode]);
                      }
                      loadingView.hidden = YES;
                      break;
              }
              NSLog(@"%d", [response errorCode]);
          }];

}

@end
