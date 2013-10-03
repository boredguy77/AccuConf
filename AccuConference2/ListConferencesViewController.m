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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
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
}

-(void)hideConferencesTable{
    self.table.hidden = YES;
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
    cell.subtitleLabel.text = conference.startTime.description;

#warning re-enable logic later
//    if(!conference.startTime || conference.startTime < [NSDate date]){
//        cell.image.image = self.cellImage;
//    } else {
        cell.image.image = nil;
        cell.imageLabelTop.text = @"May";
        cell.imageLabelBottom.text = @"1";
//    }
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
