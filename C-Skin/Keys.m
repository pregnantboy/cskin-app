//
//  Keys.m
//  C-Skin
//
//  Created by Ian Chen on 5/10/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "Keys.h"

@implementation Keys

NSString *const USER_EMAIL_KEY = @"patientEmail";
NSString *const DATE_TAKEN_KEY = @"dateTaken";
NSString *const IMAGE_FORMAT_KEY = @"images_%d";
NSString *const NUM_OF_IMAGES_KEY = @"nImages";
NSString *const DATE_SUBMISSION_KEY = @"dateSubmission";
NSString *const DETAILS_KEY = @"details";
NSString *const POST_REQUEST_URL = @"https://cskin.herokuapp.com/processImageUpload";
NSString *const GET_REQUEST_URL = @"https://cskin.herokuapp.com/getPatientImages";

@end
