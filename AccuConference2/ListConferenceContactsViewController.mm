#import "ListConferenceContactsViewController.h"
#import <EventKit/EventKit.h>

@implementation ListConferenceContactsViewController
@synthesize conference, table, participants, moderators;

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)setConference:(Conference *)conf{
    conference = conf;
    self.moderators = [NSMutableArray array];
    self.participants = [NSMutableArray array];
    
    [self.moderators addObjectsFromArray:[self.conference.moderators array]];
    [self.participants addObjectsFromArray:[self.conference.participants array]];
    isSelfParticipant = conf.isOwnerParticipant.boolValue;
    isSelfModerator = conf.isOwnerModerator.boolValue;
    
    [self.table reloadData];
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [self addModeratorPressed];
                break;
            case 1:
                isSelfModerator = !isSelfModerator;
                
                if(!isSelfModerator){
                    [self.moderators removeObject:[Contact ownerContact]];
                } else if(![self.moderators containsObject:[Contact ownerContact]]){
                    [self.moderators addObject:[Contact ownerContact]];
                }
                [self.table reloadData];
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [self addParticipantPressed];
                break;
            case 1:
                isSelfParticipant = !isSelfParticipant;
                
                if(!isSelfParticipant){
                    [self.participants removeObject:[Contact ownerContact]];
                } else if(![self.participants containsObject:[Contact ownerContact]]){
                    [self.participants addObject:[Contact ownerContact]];
                }
                [self.table reloadData];
                break;
        }
        
    }
}

#pragma mark - Tableview Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if(indexPath.section == 0){
            return [tableView dequeueReusableCellWithIdentifier:@"addModeratorsHeaderCell"];
        } else {
            return [tableView dequeueReusableCellWithIdentifier:@"addParticipantsHeaderCell"];
        }
    }else if(indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addYourselfCell"];
        UITextField *check = (UITextField *) [cell viewWithTag:1];
        if (indexPath.section == 0) {
            check.text = isSelfModerator?@"X":@"";
        } else {
            check.text = isSelfParticipant?@"X":@"";
        }
        return cell;
    } else {
        Contact *contact;
        if(indexPath.section == 0){
            contact = [self.moderators objectAtIndex:indexPath.row-2];
        } else {
            contact = [self.participants objectAtIndex:indexPath.row-2
                       ];
        }
        UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
        UIButton *deleteBtn = (UIButton *)[contactCell viewWithTag:2];
        
        [deleteBtn removeTarget:self action:@selector(deleteParticipant:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn removeTarget:self action:@selector(deletModerator::) forControlEvents:UIControlEventTouchUpInside];
        
        if(indexPath.section == 0){
            [deleteBtn addTarget:self action:@selector(deleteModerator:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [deleteBtn addTarget:self action:@selector(deleteParticipant:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *contactNameLabel = (UILabel *) [contactCell viewWithTag:1];
        UIButton *deleteButton = (UIButton *) [contactCell viewWithTag:2];
        contactNameLabel.text = [NSString stringWithFormat:@"%@ %@",contact.fName , contact.lName];
        [deleteButton addTarget:self action:@selector(deleteContactPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (contact == [Contact ownerContact]) {
            deleteBtn.hidden = YES;
        }
        
        return contactCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.moderators.count + 2;
    } else {
        return self.participants.count + 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 75;
            break;
            
        default:
            return 44;
            break;
    }
}

#pragma mark - IBActions
-(void)deleteContactPressed:(id)sender{
    
}

-(void)addModeratorPressed{
    selectedArray = self.moderators;
    [self performSegueWithIdentifier:@"toSelectContacts" sender:self];
}

-(void)addParticipantPressed{
    selectedArray = self.participants;
    [self performSegueWithIdentifier:@"toSelectContacts" sender:self];
}

-(void)deleteModerator:(id)sender{
    UIButton * button = (UIButton *) sender;
    UITableViewCell * cell = (UITableViewCell *) button.superview.superview.superview;
    NSIndexPath *index = [self.table indexPathForCell:cell];
    
    [self.moderators removeObjectAtIndex:index.row -2];
    [self.table reloadData];
    
}

-(void)deleteParticipant:(id)sender{
    UIButton * button = (UIButton *) sender;
    UITableViewCell * cell = (UITableViewCell *) button.superview.superview.superview;
    NSIndexPath *index = [self.table indexPathForCell:cell];
    
    [self.participants removeObjectAtIndex:index.row -2];
    [self.table reloadData];
}

-(void)doneButtonPressed{
    
    if(self.participants.count > 0 || self.moderators.count > 0){
        
        [self.conference setParticipants:[NSOrderedSet orderedSetWithArray:self.participants]];
        [self.conference setModerators:[NSOrderedSet orderedSetWithArray:self.moderators]];
        self.conference.isOwnerModerator = [NSNumber numberWithBool:isSelfModerator];
        self.conference.isOwnerParticipant = [NSNumber numberWithBool:isSelfParticipant];
        [Conference save:self.conference];
        EKEventStore *es = [[EKEventStore alloc] init];
        [es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                [[[UIAlertView alloc] initWithTitle:@"No Calendar Access" message:@"Unable to modify your calendar, Change settings in privacy and retry this operation" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            } else {
                [Conference addConferencesToCalendar:es];
                [Conference save:nil];
            }
        }];
        selectedArray = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Cannot Save" message:@"Meeting requires at least one contact in order to be saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

#pragma mark - List Contacts Selection Protocol

-(void)listContactsDidFinishSelecting:(NSDictionary *)contactsAndGroups{
    NSArray *selectedContacts = (NSArray *) [contactsAndGroups objectForKey:@"selectedContacts"];
    [selectedArray addObjectsFromArray:selectedContacts];
    [self.table reloadData];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListContactsViewController class]]){
        ListContactsViewController *listController = (ListContactsViewController *) segue.destinationViewController;
        listController.delegate = self;
//        listController.types = ALL | ACCUDIAL;
    }
}

@end
