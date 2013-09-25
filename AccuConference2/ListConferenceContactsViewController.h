#import <UIKit/UIKit.h>
#import "Conference.h"
#import "Contact.h"
#import "Constants.h"


@interface ListConferenceContactsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)Conference *conference;
@property(nonatomic, strong)NSDictionary *conferenceDictionary;

@property(nonatomic, strong)IBOutlet UITableView *table;
@property(nonatomic, strong)NSMutableArray *moderators;
@property(nonatomic, strong)NSMutableArray *participants;

-(void)addModeratorPressed;
-(void)addParticipantPressed;
-(void)addYourselfModeratorPressed;
-(void)addYourselfParticipantPressed;
-(void)deleteModerator:(id)sender;
-(void)deleteParticipant:(id)sender;

-(IBAction)doneButtonPressed;
@end

