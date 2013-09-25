#import "AddEditGroupViewController.h"

@implementation AddEditGroupViewController
@synthesize nameField, contacts, group;

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
    if(self.group){
        self.nameField.text = group.name;
        self.contacts = group.contacts.allObjects;
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
        grp = (Group *)[Group instance:NO];
    }
    grp.name = self.nameField.text;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:grp, @"modelGroup", self.contacts, @"contacts", nil];
    
    if(self.group){
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GROUP object:nil userInfo:dict];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_GROUP object:nil userInfo:dict];
    }
    
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
    }
}

#pragma mark - ListContactSelection Protocol
-(void)ListContactsDidFinishSelecting:(NSDictionary *)dict{
    self.contacts = (NSArray *) [dict objectForKey:@"selectedContacts"];
    [self.table reloadData];
    //= (NSArray *) [dict objectForKey:@"groups"];
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
