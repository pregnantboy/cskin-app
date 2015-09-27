//
//  ReportObject.h
//  C-Skin
//
//  Created by Ian Chen on 24/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportObject : NSObject

- (id)init;

- (void)setDate:(NSDate *)date;
- (void)setImages:(NSMutableArray *)arrayOfImages;
- (void)setDetails:(NSString *)details;
+ (NSDateFormatter *)submissionDateFormatter;

@end
