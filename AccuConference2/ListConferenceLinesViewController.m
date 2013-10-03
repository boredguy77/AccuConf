#import "ListConferenceLinesViewController.h"

@implementation ListConferenceLinesViewController

@synthesize table, noConferenceLinesLabel, setupLineButton, background, delegate, mode;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self= [super initWithCoder:aDecoder];
    if(self){
        mode = LIST_DETAIL_MODE;
        _conferenceLines = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(conferenceLinesModified:) name:CONFERENCE_LINES_MODIFIED object:nil];
    self.conferenceLines = [ConferenceLine all];
    if(self.conferenceLines.count>0) {
        [self hideNoConferenceLinesNotification];
        [self showConferenceLinesTable];
        [self.table reloadData];
    } else {
        [self hideConferenceLinesTable];
        [self showNoConferenceLinesNotification];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)hideConferenceLinesTable{
    self.table.hidden = YES;
}

-(void)hideNoConferenceLinesNotification{
    self.noConferenceLinesLabel.hidden = YES;
    self.setupLineButton.hidden = YES;
    self.background.hidden = YES;
}

-(void)showConferenceLinesTable{
    self.table.hidden = NO;
}

-(void)showNoConferenceLinesNotification{
    self.noConferenceLinesLabel.hidden = NO;
    self.setupLineButton.hidden = NO;
    self.background.hidden = NO;
}

#pragma mark - Tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConferenceLine *line = [self.conferenceLines objectAtIndex:[indexPath row]];
    if(self.mode == LIST_DETAIL_MODE){
        [self performSegueWithIdentifier:@"toConferenceLineDetail" sender:line];
    } else if(self.mode == LIST_SELECT_SINGLE_MODE){
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectConferenceLine:)]){
            [self.delegate didSelectConferenceLine:line];
#warning need to figure out where/when to change List Mode to default
//            self.mode = LIST_DETAIL_MODE;
//            self.delegate = nil;
//            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [self performSegueWithIdentifier:@"toAddEditConference" sender:line];
    }
    
}

#pragma mark - TableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConferenceLine *line = [self.conferenceLines objectAtIndex:[indexPath row]];
    SingleImageLeftSingleLineTextCell *cell = (SingleImageLeftSingleLineTextCell *)[tableView dequeueReusableCellWithIdentifier:CONFERENCE_LINE_CELL_ID];
    NSLog(@"line name %@", line.name);
    cell.label.text = line.name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conferenceLines.count;
}

#pragma mark - IBAction
-(void)addButtonPress{
    [self performSegueWithIdentifier:@"toAddEditConferenceLine" sender:self];
}

#pragma mark - Events
-(void)conferenceLinesModified:(NSNotification *)notification{
    NSLog(@"Conference Lines Modified");
    
    self.conferenceLines = (NSArray *)[notification.userInfo objectForKey:[ConferenceLine modelName]];
    
    if(self.conferenceLines.count>0) {
        [self hideNoConferenceLinesNotification];
        [self showConferenceLinesTable];
        [self.table reloadData];
    } else {
        [self hideConferenceLinesTable];
        [self showNoConferenceLinesNotification];
    }
    
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ConferenceLineDetailViewController class]]){
        ConferenceLineDetailViewController *detail = (ConferenceLineDetailViewController *) segue.destinationViewController;
        detail.conferenceLine = (ConferenceLine *)sender;
    }
    
    if([segue.destinationViewController isKindOfClass:[AddEditConferenceViewController class]]){
        AddEditConferenceViewController *addController = (AddEditConferenceViewController *) segue.destinationViewController;
        addController.conferenceLine = (ConferenceLine *) sender;
    }
}

@end
