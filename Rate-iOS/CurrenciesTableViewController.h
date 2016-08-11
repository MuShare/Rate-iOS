//
//  CurrenciesTableViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface CurrenciesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) BOOL selectable;
@property (nonatomic, strong) NSString *currencyAttributeName;

- (IBAction)selectShowType:(id)sender;
- (IBAction)setFavorite:(UIButton *)sender;

@end
