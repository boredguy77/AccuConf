#import "ListContactsViewController.h"

@implementation ListContactsViewController
@synthesize delegate, table, segmentedControl, contacts, selectedContacts;

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsChanged:) name:GROUPS_MODIFIED object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (ABAddressBookGetAuthorizationStatus() ==
        kABAuthorizationStatusAuthorized) {
        [self initContactData];
        
    } else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(ab, ^(bool granted, CFErrorRef error) {
            [self initContactData];
        });
    } else {
        self.accudialContacts = [self emptyContactArray];
        self.contacts = [self emptyContactArray];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Access denied" message:@"Database Access Denied, Give application access in settings in order to use the contacts feature" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void) initContactData{
    [self deleteDummyData];
    [self generateDummyData];
    self.contacts = [self AllContactsFromDB];
    self.accudialContacts = [self AccudialContactsFromDB];
    [self.table reloadData];
}

-(NSArray *) emptyContactArray{
    NSMutableArray *retContacts = [[NSMutableArray alloc] initWithCapacity:27];
    for (int i = 0; i < 27; i++) {
        NSMutableArray *letterContacts = [[NSMutableArray alloc] init];
        [retContacts addObject:letterContacts];
    }
    return retContacts;
}

-(NSArray *)AllContactsFromDB{
    NSLog(@"populateContactsFromDB");
    CFErrorRef er;
    
    NSArray *retContacts = [self emptyContactArray];
    
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &er);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(ab);
    
    if (people!=NULL) {
        
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                                   kCFAllocatorDefault,
                                                                   CFArrayGetCount(people),
                                                                   people
                                                                   );
        
        CFArraySortValues(
                          peopleMutable,
                          CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*) ABPersonGetSortOrdering()
                          );
        
        NSArray *allPeople = (__bridge NSArray *) peopleMutable;
        
        
        for (int i = 0; i < allPeople.count; i++) {
            CFErrorRef err;
            ABRecordRef record = (__bridge ABRecordRef)([allPeople objectAtIndex:i]);
            ABAddressBookRemoveRecord(ab, record, &err);
            ABRecordID recordID = ABRecordGetRecordID(record);
            NSLog(@"contact");
            Contact *contact = [Contact contactForRecordID:recordID];
            if(!contact) {
                contact = (Contact *)[Contact instance:YES];
                NSString *fName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
                NSString *lName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
                contact.fName = fName;
                contact.lName = lName;
                contact.recordID = [NSNumber numberWithInt:recordID];
                [Contact save:nil];
            }
            
            NSLog(@" end contact");
            
            char lNameChar =  [[contact.lName lowercaseString] characterAtIndex:0] ;
            
            int index = (int) lNameChar;
            
            if (index > 95 && index < 123) {
                index = index - 97;
            } else {
                index = 26;
            }
            
            NSMutableArray *letterArray = (NSMutableArray *)[retContacts objectAtIndex:index];
            [letterArray addObject:contact];
            
            
        }
        
        
        CFRelease(ab);
        CFRelease(people);
        CFRelease(peopleMutable);
    }
    
    return retContacts;
    
}

-(NSArray *)AccudialContactsFromDB{
    NSLog(@"groups");
    CFErrorRef error;
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:27];
    
    for (int i = 0; i < 28; i++) {
        NSMutableArray *letterContacts = [[NSMutableArray alloc] init];
        [retArray addObject:letterContacts];
    }
    
    if (ABAddressBookGetGroupCount(ab) > 0) {
        CFArrayRef groups = ABAddressBookCopyArrayOfAllGroups(ab);
        
        int arraySize = groups!=NULL?CFArrayGetCount(groups):0;
        
        NSString *accudialGroup = @"Accudial";
        
        CFMutableArrayRef accudialContacts = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
        
        //iterate each group
        for (int i = 0; i < arraySize-1; i++) {
            ABRecordRef record = CFArrayGetValueAtIndex(groups, i);
            CFStringRef* groupName = (CFStringRef *) ABRecordCopyValue(record, kABGroupNameProperty);
            NSString *nsGroupName = (NSString *) CFBridgingRelease(groupName);
            
            if(nsGroupName && [accudialGroup isEqualToString:nsGroupName]){
                NSLog(@"isEqual");
                CFArrayRef allContactsInGroup = ABGroupCopyArrayOfAllMembers(record);
                for (int i = 0; i < CFArrayGetCount(allContactsInGroup) - 1; i++) {
                    ABRecordRef groupRecord = CFArrayGetValueAtIndex(allContactsInGroup, i);
                    CFArrayAppendValue(accudialContacts, groupRecord);
                }
            }
        }
        
        //Sort Contacts
        CFArraySortValues(
                          accudialContacts,
                          CFRangeMake(0, CFArrayGetCount(accudialContacts)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*) ABPersonGetSortOrdering()
                          );
        
        NSArray *allAccudialContacts = (__bridge NSArray *) accudialContacts;
        
        for (int i = 0; i < allAccudialContacts.count; i++) {
            ABRecordRef record = (__bridge ABRecordRef)([allAccudialContacts objectAtIndex:i]);
            
            ABRecordID recordID = ABRecordGetRecordID(record);
            
            Contact *contact = [Contact contactForRecordID:recordID];
            if(!contact) {
                contact = (Contact *)[Contact instance:NO];
                NSString *fName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
                NSString *lName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
                contact.fName = fName;
                contact.lName = lName;
                contact.recordID = [NSNumber numberWithInt:recordID];
            }
            
            char lNameChar =  [[contact.lName lowercaseString] characterAtIndex:0];
            int index = (int) lNameChar;
            
            if (index > 95 && index < 123) {
                index = index - 97;
            } else {
                index = 27;
            }
            
            NSMutableArray *letterArray = (NSMutableArray *)[retArray objectAtIndex:index];
            [letterArray addObject:contact];
        }
        CFRelease(ab);
        if (groups!=NULL) {
            CFRelease(groups);
        }
        if(accudialContacts !=NULL){
            CFRelease(accudialContacts);
        }
    }
    
    
    
    return retArray;
}

-(int)indexForLetter:(char *)letter {
    int index = (int) &letter;
    index = index - 96;
    return index;
}

-(void)generateDummyData{
    CFErrorRef error;
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    ABRecordRef accudialGroup = ABGroupCreate(); //create a group
    ABRecordSetValue(accudialGroup, kABGroupNameProperty, @"Accudial", &error); // set group's name
    ABRecordRef otherGroup = ABGroupCreate(); //create a group
    ABRecordSetValue(otherGroup, kABGroupNameProperty, @"test", &error); // set group's name
    
    ABAddressBookAddRecord(ab, accudialGroup, &error); // add the group
    ABAddressBookAddRecord(ab, otherGroup, &error); // add the group
    
    for (int i = 0; i < 27; i++) {
        ABRecordRef person = ABPersonCreate();
        NSString *phone = @"0123456789"; // the phone number to add
        
        //Phone number is a list of phone number, so create a multivalue
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(phone),kABPersonPhoneMobileLabel, NULL);
        NSString *fName = [NSString stringWithFormat:@"%c", i + 97 ];
        NSString *lName = [NSString stringWithFormat:@"%c", i + 97 ];
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(fName) , nil); // first name of the new person
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(lName), nil); // last name
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, &error); // set the phone number property
        ABAddressBookAddRecord(ab, person, nil); //add the new person to the record
        
        if(i > 12){
            ABGroupAddMember(accudialGroup, person, &error); // add the person to the group
        } else {
            ABGroupAddMember(otherGroup, person, &error); // add the person to the group
        }
        
        
        
        ABAddressBookSave(ab, nil); //save the record
        CFRelease(person); // relase the ABRecordRef  variable
        
    }
    CFRelease(ab);
}

-(void)deleteDummyData{
    CFErrorRef error;
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    
    CFArrayRef allGroups = ABAddressBookCopyArrayOfAllGroups(ab);
    if(allGroups!=NULL){
    for (int i = 0; i < CFArrayGetCount(allGroups); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(allGroups, i);
        ABAddressBookRemoveRecord(ab, record, &error);
    }
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(ab);
    if(allContacts!=NULL){
    for (int i = 0; i < CFArrayGetCount(allContacts); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(allContacts, i);
        bool didRemove = ABAddressBookRemoveRecord(ab, record, &error);
        if(!didRemove){
            NSLog(@"Error Deleting Record");
        }
    }
    }
    ABAddressBookSave(ab, &error);
    CFRelease(ab);
    
}

-(void)groupsChanged:(NSNotification *)notification{
    self.groups = (NSArray *) [notification.userInfo objectForKey:@"groups"];
    [self.table reloadData];
}

#pragma mark - Tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        Contact *contact =  (Contact *)[(NSArray *) [self.accudialContacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        contact.selected = !contact.selected;
        image.hidden = !contact.selected;
    } else if(self.segmentedControl.selectedSegmentIndex == 1) {
        Contact *contact =  (Contact *)[(NSArray *) [self.contacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        contact.selected = !contact.selected;
        image.hidden = !contact.selected;
    }
}

#pragma mark - TableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"numberOfSectionsInTableView");
    return self.contacts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        if([[self.contacts objectAtIndex:section] count] > 0){
            return 30.0;
        } else {
            return 0.0;
        }
    } else {
        if([[self.accudialContacts objectAtIndex:section] count] > 0){
            return 30.0;
        } else {
            return 0.0;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    int index = section + 65;
    NSString * header;
    
    if (index > 64 && index < 91) {
        header = [NSString stringWithFormat:@"%c", section + 65];
    } else {
        header = @"#";
    }
    NSLog(@"%@", header);
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListContactsCell"];
    UILabel *title = (UILabel *) [cell viewWithTag:1];
    UIImageView *check = (UIImageView *)[cell viewWithTag:2];
    
    NSMutableArray *array;
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        array =  (NSMutableArray *) [self.accudialContacts objectAtIndex:indexPath.section];
    } else {
        array =  (NSMutableArray *) [self.contacts objectAtIndex:indexPath.section];
    }

    Contact *contact = (Contact *) [array objectAtIndex:indexPath.row];
    title.text = [NSString stringWithFormat:@"%@ %@",contact.fName, contact.lName];
    check.hidden = !contact.selected;
    NSLog(@"cellForRowAtIndexPath");
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return [(NSArray *) [self.accudialContacts objectAtIndex:section] count];
    } else {
        return [(NSArray *) [self.contacts objectAtIndex:section] count];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *titles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    return titles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

#pragma mark - segmented button press
-(void)segmentedButtonPress{
    [self.table reloadData];
    NSLog(@"selected Index %i", self.segmentedControl.selectedSegmentIndex);
}

-(void)donePressed{
    NSMutableArray *selectedContacts = [[NSMutableArray alloc] init];
    NSMutableArray *selectedGroups = [[NSMutableArray alloc] init];
    if(self.accudialContacts){
    for (NSArray *letterArray in self.accudialContacts) {
        for (Contact *contact in letterArray) {
            if(contact.selected){
                [selectedContacts addObject:contact];
                contact.selected = NO;
            }
        }
    }
    }
    
    if(self.contacts){
    for (NSArray *letterArray in self.contacts) {
        for (Contact *contact in letterArray) {
            if(contact.selected){
                [selectedContacts addObject:contact];
                contact.selected = NO;
            }
        }
    }
    }
    if(self.groups){
    for (Group *group in self.groups) {
        if(group.selected){
            [selectedGroups addObject:group];
            group.selected = NO;
        }
    }
    }
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:selectedContacts, @"selectedContacts", selectedGroups, @"selectedGroups", nil];
    if(self.delegate && [self.delegate respondsToSelector:@selector(ListContactsDidFinishSelecting:)]){
        [self.delegate ListContactsDidFinishSelecting:retDict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertview Delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
