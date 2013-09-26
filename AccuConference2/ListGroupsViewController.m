#import "ListGroupsViewController.h"


@implementation ListGroupsViewController
@synthesize noGroupsButton,noGroupsImage,noGroupsLabel,table;

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsModified:) name:GROUPS_MODIFIED object:nil];
    self.groups = [Group all];
    if(self.groups.count > 0){
        [self hideNoGroups];
        [self.table reloadData];
    } else {
        [self showNoGroups];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideNoGroups{
    self.noGroupsButton.hidden = YES;
    self.noGroupsImage.hidden = YES;
    self.noGroupsLabel.hidden = YES;
    self.table.hidden = NO;
}

-(void)showNoGroups{
    self.noGroupsButton.hidden = NO;
    self.noGroupsImage.hidden = NO;
    self.noGroupsLabel.hidden = NO;
    self.table.hidden = YES;
}

#pragma mark - Tableview Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Group *group = (Group *) [self.groups objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toAddEditGroup" sender:group];
}

#pragma mark - Tableview Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseableID"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseableID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Group *group = (Group *)[self.groups objectAtIndex:[indexPath row]];
    cell.textLabel.text = group.name;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark Events
-(void)groupsModified:(NSNotification *)notification{
    self.groups = (NSArray *) [notification.userInfo objectForKey:[Group modelName]];
    if(self.groups.count > 0){
        [self hideNoGroups];
        [self.table reloadData];
    } else {
        [self showNoGroups];
    }
}

#pragma mark - IBActions
-(void)addButtonPressed{
    [self performSegueWithIdentifier:@"toAddEditGroup" sender:nil];
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[AddEditGroupViewController class]]) {
        if(sender){
            AddEditGroupViewController *addEditGroupController = (AddEditGroupViewController*) segue.destinationViewController;
            addEditGroupController.group = (Group *)sender;
        }
    }
}

@end
