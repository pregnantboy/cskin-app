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
    
    PhotoPickerManager *_photoMgr;
}

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    _closePopUpViewsButton = [[UIButton alloc] initWithFrame:self.mainScrollView.frame];
    _closePopUpViewsButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
    [self.view addSubview:_closePopUpViewsButton];
    [self.view addSubview:self.datePickerView];
    [self.view addSubview:self.photoOptionView];
    [_closePopUpViewsButton addTarget:self action:@selector(hideAllPopUpViews) forControlEvents:UIControlEventTouchUpInside];
    [self hideClosePopUpViewsButton];
    
 
    // Initialize photoArray.
    _photoArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"doctor.png"], [UIImage imageNamed:@"inbox.png"], nil];
    _photoArray = [[NSMutableArray alloc] init];
    
    // Initialize photoOptionView
    self.photoOptionView.layer.cornerRadius = 25;
    self.photoOptionView.layer.masksToBounds = YES;
    [self hidePhotoOptionView];
    
    // Initialize PhotoPickerManager.
    _photoMgr = [[PhotoPickerManager alloc] initWithViewController:self];
    
    // Set up gesture recognizer.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(endEditingOfDetailsTextView)];
    
    [self.mainScrollView addGestureRecognizer:tap];
    
    // Set default date
    _date = [NSDate date];
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
        [self shiftDetailsTextViewUp];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.detailsTextView) {
        [self shiftDetailsTextViewDown];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.detailsTextView) {
        _details = textView.text;
    }
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

- (IBAction)cameraRollOption:(id)sender {
    [_photoMgr showImagePickerForPhotoPicker];
}

- (IBAction)cameraOption:(id)sender {
    [_photoMgr showImagePickerForCamera];
}

- (IBAction)submit:(id)sender {
    if ([_photoArray count] == 0) {
        [self showAlert:@"Upload at least one photo."];
        return;
    }
//    if (!_details || (_details.length < 5)) {
//        [self showAlert:@"Give a description of your condition."];
//        return;
//    }
    ReportObject *reportObj = [[ReportObject alloc] init];
    [reportObj setDate:_date];
    [reportObj setImages:_photoArray];
    [reportObj setDetails:_details];
    [reportObj submitObject];
    
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
    
    if (indexPath.row < [_photoArray count]) {
        static NSString *cellIdentifier = @"cell";
        
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.cameraButton setImage:[_photoArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cell.cameraButton setUserInteractionEnabled:NO];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [longPress setMinimumPressDuration:1.0];
        [cell addGestureRecognizer:longPress];
        [cell setTag:indexPath.row];
        return cell;

        
    } else {
        static NSString *cellIdentifier = @"cameraCell";
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell setImage:[UIImage imageNamed:@"photo.png"]];
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [cell removeGestureRecognizer:recognizer];
        }
        [cell.cameraButton addTarget:self action:@selector(showPhotoOptionView) forControlEvents:UIControlEventTouchUpInside];
        [cell setTag:-1];
        return cell;

    }
}

#pragma mark - Private helpers for showing/hiding views

- (void)hideAllPopUpViews {
    [self hideClosePopUpViewsButton];
    [self hideDatePickerView];
    [self hidePhotoOptionView];
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
    [self.mainScrollView bringSubviewToFront:_closePopUpViewsButton];
    [self.mainScrollView bringSubviewToFront:self.datePickerView];
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

- (void)shiftDetailsTextViewUp {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 150.0, 0.0);
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
    CGPoint bottomOffset = CGPointMake(0, self.mainScrollView.contentSize.height - self.mainScrollView.bounds.size.height+150);
    [self.mainScrollView setContentOffset:bottomOffset animated:YES];
}

- (void)shiftDetailsTextViewDown {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.4 animations:^{
        self.mainScrollView.contentInset = contentInsets;
    }];
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)showPhotoOptionView {
    self.photoOptionView.hidden = NO;
    [self showClosePopUpViewsButton];
    // bring _closePopUpViewButton above detailsContailerView
    [self.mainScrollView bringSubviewToFront:_closePopUpViewsButton];
    [self.mainScrollView bringSubviewToFront:self.photoOptionView];
    [UIView animateWithDuration:0.25 animations:^{
        self.photoOptionView.alpha = 1.0;
    }];
}

- (void)hidePhotoOptionView {
    self.photoOptionView.hidden = YES;
    self.photoOptionView.alpha = 0;
}

#pragma mark - Public methods
- (void)addPhotoToArray:(UIImage *)newImage {
    [_photoArray addObject:newImage];
    [_photoCollectionView reloadData];
    [self hideAllPopUpViews];
}

#pragma mark - Private helpers
- (BOOL)isSameDates:(NSDate *)date1 and:(NSDate*)date2 {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *date2Components = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
    return (comparison == NSOrderedSame);
}

- (void)endEditingOfDetailsTextView {
    [self.detailsTextView resignFirstResponder];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    if ([gesture.view tag] == -1 ) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete photo?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction *action){
                                                         [_photoArray removeObjectAtIndex:[gesture.view tag]];
                                                         [_photoCollectionView reloadData];
                                                     }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:actionCancel];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    [_photoCollectionView reloadData];

}

- (void)showAlert:(NSString *)string {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:string
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:actionOK];
    [self presentViewController:alertController animated:YES completion:nil];
}

// Prevents horizontal scrolling.
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender == self.mainScrollView) {
        if (sender.contentOffset.x != 0) {
            CGPoint offset = sender.contentOffset;
            offset.x = 0;
            sender.contentOffset = offset;
        }
    }
}

@end
