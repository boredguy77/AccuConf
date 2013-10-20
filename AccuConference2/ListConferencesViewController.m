#import "ListConferencesViewController.h"

@implementation ListConferencesViewController

@synthesize noConferencesLabel, createConferenceButton, background, segmentedControl, table, conferences, cellImage;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        cellImage = [UIImage imageNamed:@"callLarge.png"];
        conferences = [NSArray array];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conferencesModified:) name:CONFERENCES_MODIFIED object:nil];
    self.conferences = [Conference all];
    if(self.conferences.count > 0){
        [self showConferencesTable];
        [self hideNoConferencesNotification];
        [self.table reloadData];
    } else {
        [self hideConferencesTable];
        [self showNoConferencesNotification];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)showConferencesTable{
    self.table.hidden = NO;
    self.segmentedControl.hidden = NO;
}

-(void)hideConferencesTable{
    self.table.hidden = YES;
    self.segmentedControl.hidden = YES;
}

-(void)showNoConferencesNotification{
    self.noConferencesLabel.hidden = NO;
    self.createConferenceButton.hidden = NO;
    self.background.hidden = NO;
}

-(void)hideNoConferencesNotification{
    self.noConferencesLabel.hidden = YES;
    self.createConferenceButton.hidden = YES;
    self.background.hidden = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(void)createConferencePressed{
    [self performSegueWithIdentifier:@"toSelectConferenceLine" sender:self];
}

-(void)segmentedControlToggle:(id)sender{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.conferences = [Conference conferencesToday];
            break;
        case 1:
            self.conferences = [Conference all];
            break;
        case 2:
            self.conferences = [Conference conferencesThisMonth];
            break;
    }
    [self.table reloadData];
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Conference *conference = [self.conferences objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toConferenceDetail" sender:conference];
}

#pragma mark - Tableview Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Conference *conference = [self.conferences objectAtIndex:[indexPath row]];
    SingleImageLeftTitleAndSubTitleCell *cell = (SingleImageLeftTitleAndSubTitleCell *) [tableView dequeueReusableCellWithIdentifier:CONFERENCE_TABLE_CELL_ID];
    cell.titleLabel.text = conference.name;
    cell.subtitleLabel.text = [Conference stringFromDate:conference.startTime];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *startComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit fromDate:conference.startTime];
    
    NSString *startDay = [NSString stringWithFormat:@"%i",startComponents.day];
    
    startComponents.hour = 23;
    startComponents.minute = 59;
    
    NSDate *endOfDay = [startComponents date];
    
    if(conference.startTime > [NSDate date] && conference.startTime < endOfDay){
        cell.image.image = self.cellImage;
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM"];
        NSString *monthName = [df stringFromDate:conference.startTime];
        
        cell.image.image = nil;
        cell.imageLabelTop.text = monthName;
        cell.imageLabelBottom.text = startDay;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conferences.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListConferenceLinesViewController class]]){
        ListConferenceLinesViewController *list = (ListConferenceLinesViewController *) segue.destinationViewController;
        list.mode = LIST_SELECT_SINGLE_MODE;
    }
    if([segue.destinationViewController isKindOfClass:[ConferenceDetailViewController class]]){
        ConferenceDetailViewController *detailController = (ConferenceDetailViewController*) segue.destinationViewController;
        detailController.conference = (Conference *) sender;
    }
}

#pragma mark - Events
-(void)conferencesModified:(NSNotification *)notification{
    NSLog(@"conferences modified");
    self.conferences = (NSArray *)[notification.userInfo objectForKey:[Conference modelName]];
    if(self.conferences.count > 0){
        [self showConferencesTable];
        [self hideNoConferencesNotification];
        [self.table reloadData];
    } else {
        [self hideConferencesTable];
        [self showNoConferencesNotification];
    }
}

@end
