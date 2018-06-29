//
//  CurrencyDao.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "CurrencyDao.h"

@implementation CurrencyDao

- (Currency *)saveOrUpdateWithJSONObject:(NSObject *)object {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Currency *currency = [self getByCid:[object valueForKey:@"cid"]];
    if (currency == nil) {
        currency = [NSEntityDescription insertNewObjectForEntityForName:CurrencyEntityName
                                                 inManagedObjectContext:self.context];
    }
    currency.cid = [object valueForKey:@"cid"];
    currency.code = [object valueForKey:@"code"];
    currency.name = [object valueForKey:@"name"];
    currency.favorite = [NSNumber numberWithBool:NO];
    return currency;
}

- (Currency *)getByCid:(NSString *)cid {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"cid=%@", cid]
                             withEntityName:CurrencyEntityName];
}

- (Currency *)getByCode:(NSString *)code {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"code=%@", code]
                             withEntityName:CurrencyEntityName];
}

- (NSArray *)findAll {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:nil
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

- (NSArray *)findInCids:(NSArray *)cids{
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:[NSPredicate predicateWithFormat:@"cid IN %@", cids]
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

- (NSFetchedResultsController *)fetchRequestControllerWithFavorite:(NSNumber *)favorite
                                                           Without:(NSString *)cid
                                                       withKeyword:(NSString *)keyword {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSMutableArray *subpredicates = [[NSMutableArray alloc] init];
    if (favorite != nil) {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"favorite=%@", favorite]];
    }
    if (cid != nil) {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"cid!=%@", cid]];
    }
    if (keyword != nil) {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"code contains[cd] %@ or name contains[cd] %@", keyword, keyword]];
    }
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    NSFetchRequest *request = [self fetchRequestByPredicate:predicate
                                             withEntityName:CurrencyEntityName
                                                    orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:self.context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Perform fetch with error: %@", error);
    }
    return fetchedResultsController;
}

@end
