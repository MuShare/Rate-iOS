//
//  UserTool.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "UserTool.h"

@implementation UserTool {
    NSUserDefaults *defaults;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

@synthesize currencyRev = _currencyRev;

- (void)setCurrencyRev:(NSInteger)currencyRev {
    _currencyRev = currencyRev;
    [defaults setInteger:_currencyRev forKey:NSStringFromSelector(@selector(currencyRev))];
}

- (NSInteger)currencyRev {
    if(_currencyRev == 0) {
        _currencyRev = [defaults integerForKey:NSStringFromSelector(@selector(currencyRev))];
    }
    return _currencyRev;
}

@synthesize basedCurrencyId = _basedCurrencyId;

- (void)setBasedCurrencyId:(NSString *)basedCurrencyId {
    _basedCurrencyId = basedCurrencyId;
    [defaults setObject:_basedCurrencyId forKey:NSStringFromSelector(@selector(basedCurrencyId))];
}

- (NSString *)basedCurrencyId {
    if(_basedCurrencyId == nil) {
        _basedCurrencyId = [defaults objectForKey:NSStringFromSelector(@selector(basedCurrencyId))];
    }
    return _basedCurrencyId;
}

@synthesize lan = _lan;

- (void)setLan:(NSString *)lan {
    _lan = lan;
    [defaults setObject:lan forKey:NSStringFromSelector(@selector(lan))];
}

- (NSString *)lan {
    if(_lan == nil) {
        _lan = [defaults objectForKey:NSStringFromSelector(@selector(lan))];
    }
    return _lan;
}

@end