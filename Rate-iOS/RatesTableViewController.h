//
//  RatesTableViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 7/31/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface RatesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *basedCurrencyImageView;
@property (weak, nonatomic) IBOutlet UILabel *basedCurrencyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *basedCurrencyNameLabel;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) Currency *basedCurrency;

- (IBAction)searchCurrency:(id)sender;
- (IBAction)changeBaseCurrency:(id)sender;

@end
