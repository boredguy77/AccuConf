#import <UIKit/UIKit.h>
#import "Conference.h"
#import "Contact.h"
#import "Constants.h"
#import "ListContactsViewController.h"

@interface ListConferenceContactsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, ListContactSelectionProtocol> {
    NSMutableArray *selectedArray;
    BOOL isSelfModerator;
    BOOL isSelfParticipant;
}

@property(nonatomic, strong)Conference *conference;
@property(nonatomic, strong)IBOutlet UITableView *table;
@property(nonatomic, strong)NSMutableArray *moderators;
@property(nonatomic, strong)NSMutableArray *participants;

-(void)addModeratorPressed;
-(void)addParticipantPressed;
-(void)deleteModerator:(id)sender;
-(void)deleteParticipant:(id)sender;

-(IBAction)doneButtonPressed;
@end

