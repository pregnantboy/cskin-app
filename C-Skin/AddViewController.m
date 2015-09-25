//
//  ViewController.m
//  C-Skin
//
//  Created by Ian Chen on 21/9/15.
//  Copyright (c) 2015 Ian Chen. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController () {
    UIButton *_closePopUpViewsButton;
    
    NSDate *_date;
    NSMutableArray *_photoArray;
    NSString *_details;
    
    CGRect _originalDetailsContainerView;
}

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.view.backgroundColor = [UIColor colorWithRed:137/255.0 green:196/255.0 blue:244/255.0 alpha:1.0];
        
    // Initialize datePickerView.
    [self hideDatePickerView];
    [self.datePickerView addSubview:self.datePicker];
    self.datePickerView.backgroundColor = [UIColor whiteColor];
    self.datePickerView.layer.cornerRadius = 25;
    self.datePickerView.layer.masksToBounds = YES;
    
    // Initialize datePicker.
    self.datePicker.maximumDate = [NSDate date];
    
    
    // Initialize dateLabel.
    self.dateOfPicture.text = @"Today";

    // Initialize closePopUpviewButton.
    _closePopUpViewsButton = [[UIButton alloc] initWithFrame:self.view.frame];
    _closePopUpViewsButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
    [self.view insertSubview:_closePopUpViewsButton belowSubview:self.datePickerView];
    [_closePopUpViewsButton addTarget:self action:@selector(hideAllPopUpViews) forControlEvents:UIControlEventTouchUpInside];
    [self hideClosePopUpViewsButton];
    
    // Initialize photoArray.
    _photoArray = [[NSMutableArray alloc] init];
    
    // Initialize detailsContainerView
    [self.view bringSubviewToFront:self.detailsContainerView];
    _originalDetailsContainerView = self.detailsContainerView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.dateOfPicture) {
        [self showDatePickerView];
        // Prevents editing of date text field.
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.detailsTextView) {
        [self shiftDetailsContainerViewUp];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.detailsTextView) {
        [self hideAllPopUpViews];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.detailsTextView isFirstResponder] && [touch view] != self.detailsTextView) {
        [self.detailsTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - IBAction handlers

- (IBAction)setAsToday:(id)sender {
    _date = [NSDate date];
    self.dateOfPicture.text = @"Today";
    [self hideAllPopUpViews];
}
- (IBAction)setCustomDate:(id)sender {
    NSDate *customDate = self.datePicker.date;
    _date = customDate;
    if ([self isSameDates:customDate and:[NSDate date]]) {
        self.dateOfPicture.text = @"Today";
    } else {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd MMM yyyy"];
        self.dateOfPicture.text = [dateformatter stringFromDate:customDate];
    }
    [self hideAllPopUpViews];
}

#pragma mark - HorizontalCollectionView delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfCells = [_photoArray count] + 1;
    if (numberOfCells > 5) {
        return 5;
    }
    return numberOfCells;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Private helpers for showing/hiding views

- (void)hideAllPopUpViews {
    [self hideClosePopUpViewsButton];
    [self hideDatePickerView];
    [self shiftDetailsContainerViewDown];
    [self.view bringSubviewToFront:self.detailsContainerView];
    [self.detailsTextView resignFirstResponder];
}

- (void)hideDatePickerView {
    self.datePickerView.hidden = YES;
    self.datePickerView.alpha = 0;
}

- (void)showDatePickerView {
    self.datePickerView.hidden = NO;
    [self showClosePopUpViewsButton];
    // bring _closePopUpViewButton above detailsContailerView
    [self.view bringSubviewToFront:_closePopUpViewsButton];
    [self.view bringSubviewToFront:self.datePickerView];
    [UIView animateWithDuration:0.25 animations:^{
        self.datePickerView.alpha = 1.0;
    }];
}

- (void)showClosePopUpViewsButton {
    _closePopUpViewsButton.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _closePopUpViewsButton.alpha = 1.0;
    }];
}

- (void)hideClosePopUpViewsButton {
    _closePopUpViewsButton.hidden = YES;
    _closePopUpViewsButton.alpha = 0;
}

- (void)shiftDetailsContainerViewUp {
    NSLog(@"is called, %d", [self.detailsTextView isFirstResponder]);
    [self.detailsContainerView setFrame:CGRectMake(0, _originalDetailsContainerView.origin.y - 216, _originalDetailsContainerView.size.width, _originalDetailsContainerView.size.height)];
    [self showClosePopUpViewsButton];
    [self.view bringSubviewToFront:self.detailsContainerView];
    [self.view becomeFirstResponder];

    NSLog(@"%f", self.detailsContainerView.frame.origin.y);
}

- (void)shiftDetailsContainerViewDown {
    [self.view addSubview:self.detailsContainerView];
    [self.detailsContainerView setFrame:_originalDetailsContainerView];
}


#pragma mark - Private helpers
- (BOOL)isSameDates:(NSDate *)date1 and:(NSDate*)date2 {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *date2Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
    return (comparison == NSOrderedSame);
}


@end
