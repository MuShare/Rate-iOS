//
//  CurrencyDao.h
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "DaoTemplate.h"

#define CurrencyEntityName @"Currency"

@interface CurrencyDao : DaoTemplate

- (Currency *)saveOrUpdateWithJSONObject:(NSObject *)object;

- (Currency *)getByCid:(NSString *)cid;

- (Currency *)getByCode:(NSString *)code;

- (NSArray *)findAll;

- (NSArray *)findInCids:(NSArray *)cids;

//Create NSFetchedResultsController from CoreData
- (NSFetchedResultsController *)fetchRequestControllerWithFavorite:(NSNumber *)favorite
                                                           Without:(NSString *)cid
                                                       withKeyword:(NSString *)keyword;

@end
