#import "ConferenceDetailViewController.h"

@implementation ConferenceDetailViewController

@synthesize conference, notifyLabel, notesLabel, addToCalendarLabel, conferenceLineParticipantCodeLabel, conferenceLineModeratorCodeLabel, conferenceLineNumberLabel, conferenceLineNameLabel, contactWebView, nameLabel, isConferenceDeleted;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView .allowsSelection = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(listenerConference){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CONFERENCE_DELETED object:listenerConference];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conferenceDeleted:) name:CONFERENCE_DELETED object:self.conference];
    listenerConference = self.conference;
    
    if (!self.isConferenceDeleted && self.conference){
        [self populateUIWithConference:self.conference];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isConferenceDeleted) {
        NSLog(@"conf deleted");
        self.isConferenceDeleted = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateUIWithConference:(Conference *)conf{
    self.nameLabel.text = conf.name;
    self.timeLabel.text = [Conference stringFromInterval:conf.startTime to:conf.endTime];
    self.notesLabel.text = conf.notes;
    self.conferenceLineNameLabel.text = conf.conferenceLine.name;
    self.conferenceLineNumberLabel.text = [ConferenceLine formatStringAsPhoneNumber:conf.conferenceLine.number];
    self.conferenceLineModeratorCodeLabel.text = conf.conferenceLine.moderatorCode;
    self.conferenceLineParticipantCodeLabel.text = conf.conferenceLine.participantCode;
    self.repeatLabel.text = [Conference stringForRepeatType:conf.repeat.intValue];
    self.notifyLabel.text = [Conference stringForNotify:conf.notify.intValue];
    self.addToCalendarLabel.text = conf.addToCal.boolValue?@"YES":@"NO";
    
    NSString *contactHTML = [Conference stringForParticipantsInConference:conf];
    [self.contactWebView loadHTMLString:contactHTML baseURL:nil];
}

#pragma mark - Events
-(void)editButtonPressed{
    [self performSegueWithIdentifier:@"toAddEditConference" sender:self.conference];
}

-(void)conferenceDeleted:(NSNotification *)notification{
    NSLog(@"notification received");
    self.isConferenceDeleted = YES;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[AddEditConferenceViewController class]]){
        AddEditConferenceViewController *addEdit = (AddEditConferenceViewController *) segue.destinationViewController;
        addEdit.conference = (Conference *) sender;
    }
}



@end
