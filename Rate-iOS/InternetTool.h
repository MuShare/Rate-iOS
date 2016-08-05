//
//  InternetTool.h
//  Rate-iOS
//
//  Created by lidaye on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetResponse.h"
#import "AppDelegate.h"

#define DoaminName @"rate.mushare.cn"

@interface InternetTool : NSObject

+ (void)setRequestToken:(NSString *)token;

+ (AFHTTPSessionManager *)getSessionManager;

+ (NSString *)createUrl:(NSString *)relativePosition;

+ (NSDictionary *)getResponse:(id  _Nullable)responseObject;

@end
