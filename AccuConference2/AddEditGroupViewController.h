#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Group.h"
#import "ListContactsViewController.h"
#import "Constants.h"

@interface AddEditGroupViewController : UIViewController <ListContactSelectionProtocol, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITextField *nameField;
@property(nonatomic, strong) NSArray *contacts;
@property(nonatomic, strong) Group *group;
@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UIButton *deleteButton;

-(IBAction)addContactPressed;
-(IBAction)savePressed;
-(IBAction)deletePressed;

@end
