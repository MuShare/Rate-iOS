//
//  Subscribe+CoreDataProperties.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/9/16.
//  Copyright © 2016 MuShare. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Subscribe.h"

NS_ASSUME_NONNULL_BEGIN

@interface Subscribe (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *enable;
@property (nullable, nonatomic, retain) NSNumber *sendEmail;
@property (nullable, nonatomic, retain) NSNumber *sendSMS;
@property (nullable, nonatomic, retain) NSString *sid;
@property (nullable, nonatomic, retain) NSString *sname;
@property (nullable, nonatomic, retain) NSNumber *threshold;
@property (nullable, nonatomic, retain) NSNumber *rate;
@property (nullable, nonatomic, retain) Currency *from;
@property (nullable, nonatomic, retain) Currency *to;

@end

NS_ASSUME_NONNULL_END
