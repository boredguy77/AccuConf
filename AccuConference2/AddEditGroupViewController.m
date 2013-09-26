#import "AddEditGroupViewController.h"

@implementation AddEditGroupViewController
@synthesize nameField, contacts, group;

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

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ListContactsViewController class]]){
        ListContactsViewController *listContactsViewController = (ListContactsViewController *)segue.destinationViewController;
        listContactsViewController.delegate = self;
//        listContactsViewController.sel
    }
}

#pragma mark - ListContactSelection Protocol
-(void)ListContactsDidFinishSelecting:(NSDictionary *)dict{
    
    NSArray *selectedContacts = (NSArray *) [dict objectForKey:@"selectedContacts"];
    
    self.contacts = selectedContacts;
    [self.table reloadData];
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
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
