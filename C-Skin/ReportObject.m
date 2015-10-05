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
        _userId = @"ghosh.soham@gmail.com";
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    NSString *_dateString = [[self.class submissionDateFormatter] stringFromDate:date];
    _date = _dateString;
    NSLog(@"%@", _date);
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

- (void)submitObject {
    
    NSURL* postUrl = [NSURL URLWithString: POST_REQUEST_URL];
    [self setDateOfSubmissionAsNow];
    // Create params dictionary
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:_date  forKey:DATE_TAKEN_KEY];
    [_params setObject:_userId forKey:USER_EMAIL_KEY];
    [_params setObject:[NSNumber numberWithInteger: [_images count]] forKey:NUM_OF_IMAGES_KEY];
    [_params setObject:_details forKey:DETAILS_KEY];
    [_params setObject:_dateOfSubmission forKey: DATE_SUBMISSION_KEY];

    // Create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //Set Content-Type in HTTP header
    NSString *boundaryConstant = [NSString stringWithFormat:@"%ld", random()];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    for (int i = 0; i < [_images count]; i ++) {
        NSData *imageData = UIImageJPEGRepresentation((UIImage *)[_images objectAtIndex:0], 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *imageFileName = [NSString stringWithFormat:IMAGE_FORMAT_KEY,i];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageFileName, imageFileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%ld", (long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:postUrl];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+ (NSDateFormatter *)submissionDateFormatter {
    // Format: 2015-09-05 00:00:00
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

@end
