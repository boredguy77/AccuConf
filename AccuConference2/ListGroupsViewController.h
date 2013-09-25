#import <UIKit/UIKit.h>
#import "Group.h"
#import "Constants.h"
#import "AddEditGroupViewController.h"

@interface ListGroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *groups;
@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UILabel *noGroupsLabel;
@property(nonatomic, strong) IBOutlet UIButton *noGroupsButton;
@property(nonatomic, strong) IBOutlet UIImageView *noGroupsImage;

-(IBAction)addButtonPressed;

@end
