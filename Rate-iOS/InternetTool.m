//
//  InternetTool.m
//  Rate-iOS
//
//  Created by lidaye on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "InternetTool.h"
#import "UserTool.h"

@implementation InternetTool

+ (void)setRequestToken:(NSString *)token {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.httpSessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

+ (AFHTTPSessionManager *)getSessionManager {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UserTool *user = [[UserTool alloc] init];
    if(user.token != nil) {
        [delegate.httpSessionManager.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
        if(DEBUG) {
            NSLog(@"Session Manager init with user token %@", user.token);
        }
    }
    return delegate.httpSessionManager;
}

+ (AFHTTPSessionManager *)getSessionManagerForJSON {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UserTool *user = [[UserTool alloc] init];
    if(user.token != nil) {
        [delegate.httpSessionManagerForJSON.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
        if(DEBUG) {
            NSLog(@"Session Manager JSON init with user token %@", user.token);
        }
    }
    return delegate.httpSessionManagerForJSON;
}

+ (NSString *)createUrl:(NSString *)relativePosition {
    NSString *url=[NSString stringWithFormat:@"http://%@/%@", DoaminName, relativePosition];
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"Request URL is: %@",url);
    }
    return url;
}

+ (NSDictionary *)getResponse:(id)responseObject {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"Get Message from server: %@", response);
    }
    return response;
}
@end
