//
//  SubscribeDao.h
//  Rate-iOS
//
//  Created by lidaye on 8/8/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "DaoTemplate.h"

#define SubsribeEntityName @"Subscribe"

@interface SubscribeDao : DaoTemplate

- (Subscribe *)saveOrUpdateWithJSONObject:(NSObject *)object;

- (Subscribe *)getBySid:(NSString *)sid;

- (NSArray *)findAll;
@end
