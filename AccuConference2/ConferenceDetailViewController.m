#import "ConferenceDetailViewController.h"

@implementation ConferenceDetailViewController

@synthesize conference, notifyLabel, notesLabel, addToCalendarLabel, conferenceLineParticipantCodeLabel, conferenceLineModeratorCodeLabel, conferenceLineNumberLabel, conferenceLineNameLabel, contactWebView, nameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView .allowsSelection = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.conference){
        [self populateUIWithConference:self.conference];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateUIWithConference:(Conference *)conf{
    self.nameLabel.text = conf.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@: %@-%@",@"May",@"1", @"1:30pm",@"2:30pm"];
    self.conferenceLineNameLabel.text = conf.conferenceLine.name;
    self.conferenceLineNumberLabel.text = conf.conferenceLine.number;
    self.conferenceLineModeratorCodeLabel.text = conf.conferenceLine.moderatorCode;
    self.conferenceLineParticipantCodeLabel.text = conf.conferenceLine.participantCode;
    self.addToCalendarLabel.text = conf.addToCal.boolValue?@"YES":@"NO";
    
    NSString *contactHTML = @"<b>Me:</b> Moderator";
    [self.contactWebView loadHTMLString:contactHTML baseURL:nil];
}

#pragma mark - Events
-(void)editButtonPressed{
    [self performSegueWithIdentifier:@"toAddEditConference" sender:self.conference];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[AddEditConferenceViewController class]]){
        AddEditConferenceViewController *addEdit = (AddEditConferenceViewController *) segue.destinationViewController;
        addEdit.conference = (Conference *) sender;
    }
}



@end
