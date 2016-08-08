//
//  UserTool.h
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject

@property (nonatomic) NSInteger currencyRev;
@property (nonatomic) NSInteger subscribeRev;
@property (nonatomic, strong) NSString *basedCurrencyId;

@property (nonatomic, strong) NSString *lan;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong) NSArray *cacheRates;

@end
