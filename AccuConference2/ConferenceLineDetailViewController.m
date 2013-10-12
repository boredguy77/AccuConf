#import "ConferenceLineDetailViewController.h"

@implementation ConferenceLineDetailViewController

@synthesize conferenceLine, nameLabel, numberLabel, moderatorLabel, participantLabel, callButton, createConferenceButton, shareLineButton, table;

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.conferenceLine){
        [self populateUIWithConferenceLine:self.conferenceLine];
    }
}

-(void)conferenceLineEdited:(NSNotification *)notification{
    NSLog(@"ConferenceLineEdited");
    ConferenceLine *line = (ConferenceLine *) [notification.userInfo objectForKey:@"conferenceLine"];
    [self populateUIWithConferenceLine:line];
}

-(void)populateUIWithConferenceLine:(ConferenceLine *)line{
    self.title = line.name;
    self.nameLabel.text = line.name;
    self.numberLabel.text = line.number;
    self.moderatorLabel.text = line.moderatorCode;
    self.participantLabel.text = line.participantCode;
    if(line.conferences.count > 0){
        [self.table reloadData];
    } else {
        self.table.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setConferenceLine:(ConferenceLine *)line{
    NSLog(@"setConferenceLine");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CONFERENCE_LINE_UPDATED object:conferenceLine];
    conferenceLine = line;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conferenceLineEdited:) name:CONFERENCE_LINE_UPDATED object:nil];
    
}

#pragma mark - IBActions
-(void)editPressed{
    [self performSegueWithIdentifier:@"toAddEditConferenceLine" sender:self.conferenceLine];
}

-(void)createConferencePressed{
    [self performSegueWithIdentifier:@"toAddEditConference" sender:self.conferenceLine];
}

-(void)callInPressed{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:[self.conferenceLine numberToURL]]];
}

-(void)shareLinePressed{
    
}

#pragma mark - TableView Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"conferenceRow"];
    Conference *conference = (Conference *)[self.conferenceLine.conferences objectAtIndex:indexPath.row];
    UILabel *timeLabel = (UILabel *) [cell viewWithTag:2];
    UILabel *titleLabel = (UILabel *) [cell viewWithTag:3];
    timeLabel.text = [conference timeString];
    titleLabel.text = conference.name;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conferenceLine.conferences.count;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[AddEddConferenceLinesViewController class]]){
        AddEddConferenceLinesViewController *addEditController = (AddEddConferenceLinesViewController*) segue.destinationViewController;
        addEditController.conferenceLine = (ConferenceLine *) sender;
    } else if([segue.destinationViewController isKindOfClass:[AddEditConferenceViewController class]]){
        AddEditConferenceViewController *addEditController = (AddEditConferenceViewController *)segue.destinationViewController;
        addEditController.conferenceLine = (ConferenceLine *) sender;
    }
}
@end
