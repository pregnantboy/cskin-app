//
//  ReportObject.m
//  C-Skin
//
//  Created by Ian Chen on 24/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "ReportObject.h"
@interface ReportObject() {
    NSString *_date;
    NSMutableArray *_images;
    NSString *_details;
    NSString *_userId;
    NSString *_dateOfSubmission;
}
@end

@implementation ReportObject

- (id)init {
    self = [super init];
    if (self) {
        _userId = @"test user";
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    NSString *_dateString = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];
    _date = _dateString;
}

- (void)setImages:(NSMutableArray *)arrayOfImages {
    _images = arrayOfImages;
}

- (void)setDetails:(NSString *)details {
    _details = details;
}

- (void)setDateOfSubmissionAsNow {
    _dateOfSubmission = [[self.class submissionDateFormatter] stringFromDate:[NSDate date]];
}

+ (NSDateFormatter *)submissionDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    return dateFormatter;
}

@end
