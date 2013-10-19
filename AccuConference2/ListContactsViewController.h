#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "Contact.h"
#import "Group.h"
#import "Constants.h"
@protocol ListContactSelectionProtocol;

@interface ListContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) id<ListContactSelectionProtocol> delegate;
@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *accudialContacts;
@property(nonatomic, strong) NSArray *groups;
@property(nonatomic, strong) NSArray *selectedContacts;

-(IBAction)segmentedButtonPress;
-(IBAction)donePressed;
-(void)groupsChanged:(NSNotification *)notification;

@end

@protocol ListContactSelectionProtocol <NSObject>

@required
-(void)listContactsDidFinishSelecting:(NSDictionary *)contactsAndGroups;

@end
