#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "Contact.h"
#import "Group.h"
#import "Constants.h"
@protocol ListContactSelectionProtocol;
typedef enum{
    ALL = 1 << 0,
    ACCUDIAL = 1 << 1,
    GROUPS = 2 << 2
} LIST_CONTACTS_TYPES;

@interface ListContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    int allContactsIndex, accudialContactsIndex, groupsIndex;
}

@property(nonatomic, strong) id<ListContactSelectionProtocol> delegate;
@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) NSArray *accudialContacts;
@property(nonatomic, strong) NSArray *groups;
@property(nonatomic, strong) NSArray *selectedContacts;
@property(nonatomic) LIST_CONTACTS_TYPES types;

-(IBAction)segmentedButtonPress;
-(IBAction)donePressed;
-(void)groupsChanged:(NSNotification *)notification;

@end

@protocol ListContactSelectionProtocol <NSObject>

@required
-(void)listContactsDidFinishSelecting:(NSDictionary *)contactsAndGroups;

@end
