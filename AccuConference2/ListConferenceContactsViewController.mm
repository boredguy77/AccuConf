#import "ListConferenceContactsViewController.h"

@implementation ListConferenceContactsViewController
@synthesize conference, table, participants, moderators;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.participants = [[NSMutableArray alloc] init];
    self.moderators = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.moderators removeAllObjects];
    [self.participants removeAllObjects];
    [self.moderators addObjectsFromArray:[self.conference.moderators array]];
    [self.participants addObjectsFromArray:[self.conference.participants array]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
                [self addModeratorPressed];
                break;
            case 1:
                [self addYourselfModeratorPressed];
                break;
                
            default:
                [self deleteModerator:[self.conference.moderators objectAtIndex:indexPath.row-2]];
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [self addParticipantPressed];
                break;
            case 1:
                [self addYourselfParticipantPressed];
                break;
                
            default:
                [self deleteParticipant:[self.conference.participants objectAtIndex:indexPath.row-2]];
                break;
        }
        
    }
}

-(void)deleteContactPressed:(id)sender{
    
}

-(void)addModeratorPressed{
    [self performSegueWithIdentifier:@"toSelectContacts" sender:self];
}

-(void)addParticipantPressed{
    [self performSegueWithIdentifier:@"toSelectContacts" sender:self];
}

-(void)addYourselfModeratorPressed{
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:path];
    UITextField *checkBox = (UITextField *) [cell viewWithTag:1];
    if ([checkBox.text isEqualToString:@"X"]) {
        checkBox.text = @"";
    } else {
        checkBox.text = @"X";
    }
}

-(void)addYourselfParticipantPressed{
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:path];
    UITextField *checkBox = (UITextField *) [cell viewWithTag:1];
    if ([checkBox.text isEqualToString:@"X"]) {
        checkBox.text = @"";
    } else {
        checkBox.text = @"X";
    }
}

-(void)deleteModerator:(id)sender{
    
}

-(void)deleteParticipant:(id)sender{
    
}

-(void)doneButtonPressed{
    
    [Conference save:self.conference];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        return cell;
    } else {
        Contact *contact;
        if(indexPath.section == 0){
            contact = [self.conference.moderators objectAtIndex:indexPath.row];
        } else {
            contact = [self.conference.participants objectAtIndex:indexPath.row
                       ];
        }
        UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
        UILabel *contactNameLabel = (UILabel *) [contactCell viewWithTag:1];
        UIButton *deleteButton = (UIButton *) [contactCell viewWithTag:2];
        contactNameLabel.text = [NSString stringWithFormat:@"%@ %@",contact.fName, contact.lName];
        [deleteButton addTarget:self action:@selector(deleteContactPressed:) forControlEvents:UIControlEventTouchUpInside];
        return contactCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.conference.moderators.count + 2;
    } else {
        return self.conference.participants.count + 2;
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

@end
