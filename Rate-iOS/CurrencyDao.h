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

- (Currency *)saveOrUpdateWithJSONObject:(NSObject *)object forLanguage:(NSString *)lan;

- (Currency *)getByCid:(NSString *)cid forLanguage:(NSString *)lan;

- (Currency *)getByCode:(NSString *)code forLanguage:(NSString *)lan;

- (NSArray *)findByLanguage:(NSString *)lan;

- (NSArray *)findInCids:(NSArray *)cids forLanguage:(NSString *)lan;

@end
