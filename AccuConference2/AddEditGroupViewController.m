#import "AddEditGroupViewController.h"

@implementation AddEditGroupViewController
@synthesize nameField, contacts, group, deleteButton;

- (void)viewDidLoad{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    if(self.group){
        self.title = self.group.name;
        self.nameField.text = group.name;
        self.contacts = group.contacts.allObjects;
    } else {
        self.title = @"Add New Group";
        self.contacts = [NSArray array];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.group){
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(void)addContactPressed{
    [self performSegueWithIdentifier:@"toListContacts" sender:self];
}

-(void)savePressed{
    Group *grp;
    if(self.group){
        grp = self.group;
    } else {
        grp = (Group *)[Group instance:YES];
    }
    grp.name = self.nameField.text;
    grp.contacts = [NSSet setWithArray:self.contacts];
    [Group save:grp];
    
    
    self.nameField.text = @"";
    self.contacts = nil;
    self.group = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deletePressed{
    [Group remove:self.group];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteContact:(id)sender{
    NSLog(@"deleteContact");
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *) btn.superview.superview.superview;
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    Contact *contact = (Contact *) [self.contacts objectAtIndex:indexPath.row];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.contacts];
    [tmpArray removeObject:contact];
    self.contacts = tmpArray;
    [self.table reloadData];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListContactsViewController class]]){
        ListContactsViewController *listContactsViewController = (ListContactsViewController *)segue.destinationViewController;
        listContactsViewController.delegate = self;
        listContactsViewController.types = ALL | ACCUDIAL;
    }
}

#pragma mark - ListContactSelection Protocol
-(void)listContactsDidFinishSelecting:(NSDictionary *)dict{
    NSLog(@"listContactsDidFinishSelecting");
    NSArray *selectedContacts = (NSArray *) [dict objectForKey:@"selectedContacts"];
    
    self.contacts = [self.contacts arrayByAddingObjectsFromArray:selectedContacts];
    [self.table reloadData];
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListContactsCell"];
    UIButton *btn = (UIButton *) [cell viewWithTag:2];
    
    [btn addTarget:self action:@selector(deleteContact:) forControlEvents:UIControlEventTouchUpInside];
    
    Contact *contact = (Contact *) [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",contact.fName, contact.lName];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
