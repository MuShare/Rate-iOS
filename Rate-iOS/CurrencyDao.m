//
//  CurrencyDao.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "CurrencyDao.h"

@implementation CurrencyDao

- (Currency *)saveOrUpdateWithJSONObject:(NSObject *)object forLanguage:(NSString *)lan {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Currency *currency = [self getByCid:[object valueForKey:@"cid"] forLanguage:lan];
    NSLog(@"%@", self.context);
    if(currency == nil) {
        currency = [NSEntityDescription insertNewObjectForEntityForName:CurrencyEntityName
                                                 inManagedObjectContext:self.context];
    }
    currency.cid = [object valueForKey:@"cid"];
    currency.code = [object valueForKey:@"code"];
    currency.icon = [object valueForKey:@"icon"];
    currency.name = [object valueForKey:@"name"];
    currency.lan = lan;
    return currency;
}

- (Currency *)getByCid:(NSString *)cid forLanguage:(NSString *)lan {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"cid=%@", cid]
                             withEntityName:CurrencyEntityName];
}

- (Currency *)getByCode:(NSString *)code forLanguage:(NSString *)lan {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"code=%@ and lan=%@", code, lan]
                             withEntityName:CurrencyEntityName];
}

- (NSArray *)findByLanguage:(NSString *)lan {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:[NSPredicate predicateWithFormat:@"lan=%@", lan]
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

- (NSArray *)findInCids:(NSArray *)cids forLanguage:(NSString *)lan {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:[NSPredicate predicateWithFormat:@"cid IN %@ and lan=%@", cids, lan]
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

@end
