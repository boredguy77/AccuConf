#import "AddEditConferenceViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddEditConferenceViewController

@synthesize conference, conferenceLineModeratorCodeLabel, conferenceLineNameLabel, conferenceLineNumberLabel, conferenceLineParticipantCodeLabel, nameField,notesField, startTimeField, endTimeField, addToCalSwitch, notifyButton, repeatButton, scheduleView, conferenceLine, deleteButton, datePicker, datePickerView, scrollview, pickerView, picker, deleteConstraint;

- (void)viewDidLoad{
    [super viewDidLoad];
    radioArray = [NSArray arrayWithObjects:self.scheduleConferenceButton, self.immediateConferenceButton, nil];
	// Do any additional setup after loading the view.
    radioImage = [UIImage imageNamed:@"radio.png"];
    radioPressedImage = [UIImage imageNamed:@"radioPressed.png"];
    [self pressRadio:self.immediateConferenceButton];
    self.scheduleView.layer.opacity = 0.0f;
    self.scrollview.contentSize = CGSizeMake(self.scrollview.contentSize.width, self.view.frame.size.height + 200);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    if(self.conferenceLine) {
        self.conferenceLineNameLabel.text = self.conferenceLine.name;
        self.conferenceLineNumberLabel.text = self.conferenceLine.number;
        self.conferenceLineModeratorCodeLabel.text = self.conferenceLine.moderatorCode;
        self.conferenceLineParticipantCodeLabel.text = self.conferenceLine.participantCode;
    }
    if(self.conference){
        [self populateUIWithConference:self.conference];
        self.deleteButton.hidden = NO;
        [self showDeleteButton:NO];
        [self pressRadio:nil];
    } else {
        self.deleteButton.hidden = YES;
        [self hideDeleteButton:NO];
        self.title = @"Create Conference";
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.isDeleteShowing){
//        self.scrollview.contentSize = CGSizeMake(self.scrollview.contentSize.width, self.scrollview.contentSize.height + 200);
    } else {
    }
}

-(void)showDatePicker:(BOOL)animated{
    self.isDatePickerShowing = YES;
    CGRect newFrame = CGRectMake(0, 0, self.datePickerView.frame.size.width, self.view.frame.size.height);
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.datePickerView.frame = newFrame;
        }];
    } else {
        self.datePickerView.frame = newFrame;
    }
}

-(void)hideDatePicker:(BOOL)animated{
    self.isDatePickerShowing = NO;
    CGRect newFrame = CGRectMake(0, self.datePickerView.frame.size.height, self.datePickerView.frame.size.width, self.view.frame.size.height);
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.datePickerView.frame = newFrame;
        }];
    } else {
        self.datePickerView.frame = newFrame;
    }
}

-(void)showPicker:(BOOL)animated{
    self.isPickerShowing = YES;
    CGRect newFrame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.view.frame.size.height);
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.pickerView.frame = newFrame;
        }];
    } else {
        self.pickerView.frame = newFrame;
    }
}

-(void)hidePicker:(BOOL)animated{
    self.isPickerShowing = NO;
    CGRect newFrame = CGRectMake(0, self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.view.frame.size.height);
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.pickerView.frame = newFrame;
        }];
    } else {
        self.pickerView.frame = newFrame;
    }
}

-(void)showScheduleConference{
    self.scheduleView.hidden = NO;
    [UIView animateWithDuration:.75 animations:^{
        self.scheduleView.layer.opacity = 1.0f;
    }];
}

-(void)hideScheduleConference{
    [UIView animateWithDuration:.75 animations:^{
        self.scheduleView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        self.scheduleView.hidden = YES;
    }];
}

-(void)showDeleteButton:(BOOL)animated{
    self.isDeleteShowing = YES;
    deleteConstraint.constant = (self.scheduleView.frame.size.height * -1) + 8;
    if (animated) {
        [UIView animateWithDuration:.75 animations:^{
            [deleteButton layoutIfNeeded];
        }];
    } else {
        [deleteButton layoutIfNeeded];
    }
}

-(void)hideDeleteButton:(BOOL)animated{
    self.isDeleteShowing = NO;
    deleteConstraint.constant = -10;
    if (animated) {
        [UIView animateWithDuration:.75 animations:^{
            [deleteButton layoutIfNeeded];
        }];
    } else {
        [deleteButton layoutIfNeeded];
    }
}

-(void)populateUIWithConference:(Conference *)conf{
    self.conferenceLineNameLabel.text = self.conference.conferenceLine.name;
    self.conferenceLineNumberLabel.text = self.conference.conferenceLine.number;
    self.conferenceLineModeratorCodeLabel.text = self.conference.conferenceLine.moderatorCode;
    self.conferenceLineParticipantCodeLabel.text = self.conference.conferenceLine.participantCode;
    self.title = self.conference.name;
    self.nameField.text = self.conference.name;
    self.notesField.text = self.conference.notes;
    
    self.startTimeField.text = [Conference stringFromDate:self.conference.startTime];
    self.endTimeField.text = [Conference stringFromDate:self.conference.endTime];
    startDate = conf.startTime;
    endDate = conf.endTime;
    notifySetting = self.conference.notify.intValue;
    repeatSetting = self.conference.repeat.intValue;
    
    [self.notifyButton setTitle:[Conference stringForNotify:notifySetting] forState:UIControlStateNormal];
    [self.repeatButton setTitle:[Conference stringForRepeatType:repeatSetting] forState:UIControlStateNormal];
    self.addToCalSwitch.on = self.conference.addToCal.boolValue;
}

-(void)pressRadio:(UIButton *)radio{
    for (UIButton *button in radioArray) {
        [button setImage:radioImage forState:UIControlStateNormal];
    }
    if(radio){
        [radio setImage:radioPressedImage forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateConferenceWithUI:(Conference *)conf{
    conf.name = self.nameField.text;
    conf.notes = self.notesField.text;
    if(startImmediately){
        conf.startTime = [NSDate date];
        conf.endTime = [[NSDate date] dateByAddingTimeInterval:3600];
    } else {
        if (!startDate) {
            startDate = [NSDate date];
        }
        if (!endDate) {
            endDate = [NSDate date];
        }
        conf.startTime = startDate;
        conf.endTime = endDate;
    }
    conf.repeat = [NSNumber numberWithInt:repeatSetting];
    conf.notify = [NSNumber numberWithInt:notifySetting];
    conf.addToCal = [NSNumber numberWithBool:self.addToCalSwitch.on];
}

#pragma mark - IBAction
-(void)nextButtonPressed{
    if(!self.isDatePickerShowing && !self.isPickerShowing){
        if (!self.conference) {
            self.conference = (Conference *)[Conference instance:YES];
            self.conference.conferenceLine = conferenceLine;
        }
        [self populateConferenceWithUI:self.conference];
        
        [self performSegueWithIdentifier:@"toAddContactsToConference" sender:self.conference];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Continue" message:@"Please finish operation before proceeding" delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

-(void)startImmediatelyButtonPressed{
    [self pressRadio:self.immediateConferenceButton];
    startImmediately = YES;
    [self hideScheduleConference];
    [self showDeleteButton:YES];
}

-(void)scheduleButtonPressed{
    startImmediately = NO;
    [self pressRadio:self.scheduleConferenceButton];
    [self showScheduleConference];
    [self hideDeleteButton:YES];
}

-(void)deleteButtonPressed{
    [Conference remove:self.conference];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dateFieldPressed:(id)sender{
    UITextField *textField = (UITextField *) sender;
    
    selectedTextField = textField;
    
    if (selectedTextField == self.startTimeField) {
        self.datePicker.date = self.conference.startTime;
    } else {
        self.datePicker.date = self.conference.endTime;
    }
    
    if(!self.isDatePickerShowing){
        
        [self showDatePicker:YES];
    }
}

-(void)datePickerDonePressed{
    if (selectedTextField == self.startTimeField) {
        startDate = self.datePicker.date;
    } else {
        endDate = self.datePicker.date;
    }
    
    selectedTextField.text = [Conference stringFromDate:self.datePicker.date];
    [self showScheduleConference];
    [self hideDatePicker:YES];
}

-(void)pickerDonePressed{
    [self hidePicker:YES];
    
    if (selectedButton) {
        if (selectedButton == self.notifyButton) {
            NSString *title = [Conference stringForNotify:notifySetting];
            NSLog(@"setting to : %@",title);
            [self.notifyButton setTitle:title forState:UIControlStateNormal];
        } else {
            NSString *title = [Conference stringForRepeatType:repeatSetting];
            NSLog(@"setting to : %@",title);
            [self.repeatButton setTitle:title forState:UIControlStateNormal];
        }
    }
}

-(void)pickerFieldPressed:(id)sender{
    NSLog(@"pickerfieldpressed");
    selectedButton = (UIButton *) sender;
    [self.picker reloadAllComponents];
    [self.picker selectRow:selectedButton==self.notifyButton?notifySetting:repeatSetting inComponent:0 animated:NO];
    [self showPicker:YES];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListConferenceContactsViewController class]]){
        ListConferenceContactsViewController *addContacts = (ListConferenceContactsViewController *) segue.destinationViewController;
        addContacts.conference = (Conference *)sender;
    }
    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self dateFieldPressed:textField];
    return NO;
}

#pragma mark - UIPicker Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"selected Picker Row");
    if (selectedButton) {
        if (selectedButton == self.notifyButton) {
            notifySetting = row;
        } else {
            repeatSetting = row;
        }
    }
}

#pragma mark - UIPicker Datasource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (selectedButton) {
        return 5;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    
    if (selectedButton) {
        if (selectedButton == self.notifyButton) {
            title = [Conference stringForNotify:row];
        } else {
            title = [Conference stringForRepeatType:row];
        }
    } else {
        title = @"";
    }
    return title;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


@end
