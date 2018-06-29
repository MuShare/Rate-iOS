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

//#define DoaminName @"rate.mushare.cn"
#define DoaminName @"127.0.0.1:8080"
#define BaiduNewsApi @"http://apis.baidu.com/showapi_open_bus/channel_news/search_news"
#define BaiduNewsApiKey @"62f182d039955833270e2d32f1861f6c"

@interface InternetTool : NSObject

//Clear token in AFHTTPSessionManager
+ (void)clearToken;

//Get AFHTTPSessionManager with token if signed in
+ (AFHTTPSessionManager *)getSessionManager;

+ (AFHTTPSessionManager *)getSessionManagerForJSON;

+ (AFHTTPSessionManager *)getNewsSessionManager;

+ (NSString *)createUrl:(NSString *)relativePosition;

+ (NSDictionary *)getResponse:(id  _Nullable)responseObject;

@end
