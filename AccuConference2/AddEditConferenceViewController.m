#import "AddEditConferenceViewController.h"

@implementation AddEditConferenceViewController

@synthesize conference, conferenceLineModeratorCodeLabel, conferenceLineNameLabel, conferenceLineNumberLabel, conferenceLineParticipantCodeLabel, nameField,notesField, startTimeField, endTimeField, addToCalSwitch, notifyLabel, repeatLabel, scheduleView, conferenceLine;

- (void)viewDidLoad{
    [super viewDidLoad];
    radioArray = [NSArray arrayWithObjects:self.scheduleConferenceButton, self.immediateConferenceButton, nil];
	// Do any additional setup after loading the view.
    radioImage = [UIImage imageNamed:@"radio.png"];
    radioPressedImage = [UIImage imageNamed:@"radioPressed.png"];
    [self pressRadio:self.immediateConferenceButton];
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
    } else {
        self.title = @"Create Conference";
    }
}

-(void)populateUIWithConference:(Conference *)conf{
    self.conferenceLineNameLabel.text = self.conference.conferenceLine.name;
    self.conferenceLineNumberLabel.text = self.conference.conferenceLine.number;
    self.conferenceLineModeratorCodeLabel.text = self.conference.conferenceLine.moderatorCode;
    self.conferenceLineParticipantCodeLabel.text = self.conference.conferenceLine.participantCode;
    self.title = self.conference.name;
    self.notesField.text = self.conference.notes;
    self.startTimeField.text = self.conference.startTime.description;
    self.endTimeField.text = self.conference.endTime.description;
    self.notifyLabel.text = self.conference.notify.stringValue;
    self.repeatLabel.text = self.conference.repeat.stringValue;
    self.addToCalSwitch.on = self.conference.addToCal.boolValue;
    
}

-(void)pressRadio:(UIButton *)radio{
    for (UIButton *button in radioArray) {
        [button setImage:radioImage forState:UIControlStateNormal];
    }
    [radio setImage:radioPressedImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateConferenceWithUI:(Conference *)conf{
    conf.name = self.nameField.text;
    conf.notes = self.notesField.text;
    conf.startTime = [NSDate date];
    conf.endTime = [NSDate date];
    conf.repeat = [NSNumber numberWithInt:self.repeatLabel.text.intValue];
    conf.notify = [NSNumber numberWithInt:self.notifyLabel.text.intValue];
    conf.addToCal = [NSNumber numberWithBool:self.addToCalSwitch.on];
}

#pragma mark - IBAction
-(void)nextButtonPressed{
    Conference *modelConference = (Conference *)[Conference instance:YES];
    self.conference = modelConference;
    [self populateConferenceWithUI:modelConference];
    modelConference.conferenceLine = conferenceLine;
    
    [self performSegueWithIdentifier:@"toAddContactsToConference" sender:modelConference];
}

-(void)startButtonPressed{
    [self pressRadio:self.immediateConferenceButton];
    self.scheduleView.hidden = YES;
}

-(void)scheduleButtonPressed{
    [self pressRadio:self.scheduleConferenceButton];
    self.scheduleView.hidden = NO;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListConferenceContactsViewController class]]){
        ListConferenceContactsViewController *addContacts = (ListConferenceContactsViewController *) segue.destinationViewController;
        addContacts.conference = (Conference *)sender;
        
    }
    
}
@end
