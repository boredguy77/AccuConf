#import "AddEditConferenceViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddEditConferenceViewController

@synthesize conference, conferenceLineModeratorCodeLabel, conferenceLineNameLabel, conferenceLineNumberLabel, conferenceLineParticipantCodeLabel, nameField,notesField, startTimeField, endTimeField, addToCalSwitch, notifyLabel, repeatLabel, scheduleView, conferenceLine, deleteButton, datePicker, datePickerView, scrollview, pickerView, picker;

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
    
    if(self.conferenceLine) {
        self.conferenceLineNameLabel.text = self.conferenceLine.name;
        self.conferenceLineNumberLabel.text = self.conferenceLine.number;
        self.conferenceLineModeratorCodeLabel.text = self.conferenceLine.moderatorCode;
        self.conferenceLineParticipantCodeLabel.text = self.conferenceLine.participantCode;
    }
    if(self.conference){
        [self populateUIWithConference:self.conference];
        [self hidePicker:NO];
        [self hideDatePicker:NO];
        self.deleteButton.hidden = NO;
        [self pressRadio:nil];
    } else {
        [self hideDatePicker:NO];
        self.deleteButton.hidden = YES;
        self.title = @"Create Conference";
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void)showDatePicker:(BOOL)animated{
    CGRect newFrame = CGRectMake(0, 0, self.datePickerView.frame.size.width, self.view.frame.size.height);
    self.deleteButton.hidden = YES;
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.datePickerView.frame = newFrame;
        }];
    } else {
        self.datePickerView.frame = newFrame;
    }
}

-(void)hideDatePicker:(BOOL)animated{
    CGRect newFrame = CGRectMake(0, self.datePickerView.frame.size.height, self.datePickerView.frame.size.width, self.view.frame.size.height);
    self.deleteButton.hidden = NO;
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.datePickerView.frame = newFrame;
        }];
    } else {
        self.datePickerView.frame = newFrame;
    }
}

-(void)showPicker:(BOOL)animated{
    CGRect newFrame = CGRectMake(0, 0, self.pickerView.frame.size.width, self.view.frame.size.height);
    self.deleteButton.hidden = YES;
    if(animated) {
        [UIView animateWithDuration:.5 animations:^{
            self.pickerView.frame = newFrame;
        }];
    } else {
        self.pickerView.frame = newFrame;
    }
}

-(void)hidePicker:(BOOL)animated{
    CGRect newFrame = CGRectMake(0, self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.view.frame.size.height);
    self.deleteButton.hidden = NO;
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

-(void)showDeleteButton{
    self.scheduleView.hidden = NO;
    [UIView animateWithDuration:.75 animations:^{
        self.deleteButton.frame = CGRectMake(self.deleteButton.frame.origin.x, self.deleteButton.frame.origin.y + 194, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
    }];
    
}

-(void)hideDeleteButton{
    [UIView animateWithDuration:.75 animations:^{
        self.deleteButton.frame = CGRectMake(self.deleteButton.frame.origin.x, self.deleteButton.frame.origin.y - 194, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
    }];
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
    self.notifyLabel.text = [Conference stringForNotify:self.conference.notify.intValue];
    self.repeatLabel.text = [Conference stringForRepeatType:self.conference.repeat.intValue];
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
        conf.startTime = startDate;
        conf.endTime = endDate;
    }
    conf.repeat = [NSNumber numberWithInt:self.repeatLabel.text.intValue];
    conf.notify = [NSNumber numberWithInt:self.notifyLabel.text.intValue];
    conf.addToCal = [NSNumber numberWithBool:self.addToCalSwitch.on];
}

#pragma mark - IBAction
-(void)nextButtonPressed{
    
    if (!self.conference) {
        self.conference = (Conference *)[Conference instance:YES];
        self.conference.conferenceLine = conferenceLine;
    }
    [self populateConferenceWithUI:self.conference];
    
    [self performSegueWithIdentifier:@"toAddContactsToConference" sender:self.conference];
}

-(void)startImmediatelyButtonPressed{
    [self pressRadio:self.immediateConferenceButton];
    startImmediately = YES;
    [self hideScheduleConference];
    [self hideDeleteButton];
}

-(void)scheduleButtonPressed{
    startImmediately = NO;
    [self pressRadio:self.scheduleConferenceButton];
    [self showScheduleConference];
    [self showDeleteButton];
}

-(void)deleteButtonPressed{
    [Conference remove:self.conference];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dateFieldPressed:(id)sender{
    if(!self.isDatePickerShowing){
        [self hideScheduleConference];
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
//    selectedLabel.text = picker.
    [self hidePicker:YES];
}

-(void)pickerFieldPressed:(id)sender{
    selectedLabel = (UILabel *) sender;
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
    if (selectedTextField == self.startTimeField) {
        self.datePicker.date = self.conference.startTime;
    } else {
        self.datePicker.date = self.conference.endTime;
    }
    [self dateFieldPressed:textField];
    selectedTextField = textField;
    return NO;
}

#pragma mark - UIPicker Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"selected Picker Row");
    
}

#pragma mark - UIPicker Datasource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"a";
}


@end
