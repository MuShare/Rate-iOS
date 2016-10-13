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

@synthesize subscribeRev = _subscribeRev;

- (void)setSubscribeRev:(NSInteger)subscribeRev {
    _subscribeRev = subscribeRev;
    [defaults setInteger:_subscribeRev forKey:NSStringFromSelector(@selector(subscribeRev))];
}

- (NSInteger)subscribeRev {
    if(_subscribeRev == 0) {
        _subscribeRev = [defaults integerForKey:NSStringFromSelector(@selector(subscribeRev))];
    }
    return _subscribeRev;
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

@synthesize showFavorites = _showFavorites;

- (void)setShowFavorites:(BOOL)showFavorites {
    [defaults setBool:showFavorites forKey:NSStringFromSelector(@selector(showFavorites))];
}

- (BOOL)showFavorites {
    return [defaults boolForKey:NSStringFromSelector(@selector(showFavorites))];
}

@synthesize notification = _notification;

- (void)setNotification:(BOOL)notification {
    [defaults setBool:notification forKey:NSStringFromSelector(@selector(notification))];
}

- (BOOL)notification {
    return [defaults boolForKey:NSStringFromSelector(@selector(notification))];
}

@synthesize email = _email;

- (void)setEmail:(NSString *)email {
    _email = email;
    [defaults setObject:_email forKey:NSStringFromSelector(@selector(email))];
}

- (NSString *)email {
    if(_email == nil) {
        _email = [defaults objectForKey:NSStringFromSelector(@selector(email))];
    }
    return _email;
}

@synthesize name = _name;

- (void)setName:(NSString *)name {
    _name = name;
    [defaults setObject:_name forKey:NSStringFromSelector(@selector(name))];
}

- (NSString *)name {
    if(_name == nil) {
        _name = [defaults objectForKey:NSStringFromSelector(@selector(name))];
    }
    return _name;
}

@synthesize telephone = _telephone;

- (void)setTelephone:(NSString *)telephone {
    _telephone = telephone;
    [defaults setObject:_telephone forKey:NSStringFromSelector(@selector(telephone))];
}

- (NSString *)telephone {
    if(_telephone == nil) {
        _telephone = [defaults objectForKey:NSStringFromSelector(@selector(telephone))];
    }
    return _telephone;
}


@synthesize token = _token;

- (void)setToken:(NSString *)token {
    _token = token;
    [defaults setObject:_token forKey:NSStringFromSelector(@selector(token))];
}

- (NSString *)token {
    if(_token == nil) {
        _token = [defaults objectForKey:NSStringFromSelector(@selector(token))];
    }
    return _token;
}

@synthesize deviceToken = _deviceToken;

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
    [defaults setObject:_deviceToken forKey:NSStringFromSelector(@selector(deviceToken))];
}

- (NSString *)deviceToken {
    if(_deviceToken == nil) {
        _deviceToken = [defaults objectForKey:NSStringFromSelector(@selector(deviceToken))];
    }
    return _deviceToken;
}

@synthesize cacheRates = _cacheRates;

- (void)setCacheRates:(NSArray *)cacheRates {
    _cacheRates = cacheRates;
    [defaults setObject:_cacheRates forKey:NSStringFromSelector(@selector(cacheRates))];
}

- (NSArray *)cacheRates {
    if (_cacheRates == nil) {
        _cacheRates = [defaults objectForKey:NSStringFromSelector(@selector(cacheRates))];
    }
    return _cacheRates;
}

- (void)clearup {
    [self setSubscribeRev:0];
    [self setEmail:nil];
    [self setToken:nil];
    [self setName:nil];
    [self setToken:nil];

    [self setCacheRates:nil];
}

@end
