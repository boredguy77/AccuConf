#import <UIKit/UIKit.h>
#import "ConferenceLine.h"
#import "AddEddConferenceLinesViewController.h"
#import "AddEditConferenceViewController.h"

@interface ConferenceLineDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) ConferenceLine *conferenceLine;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *numberLabel;
@property(nonatomic, strong) IBOutlet UILabel *moderatorLabel;
@property(nonatomic, strong) IBOutlet UILabel *participantLabel;
@property(nonatomic, strong) IBOutlet UIButton *callButton;
@property(nonatomic, strong) IBOutlet UIButton *createConferenceButton;
@property(nonatomic, strong) IBOutlet UIButton *shareLineButton;
@property(nonatomic, strong) IBOutlet UITableView *table;

-(IBAction)callInPressed;
-(IBAction)createConferencePressed;
-(IBAction)shareLinePressed;
-(IBAction)editPressed;

-(void)conferenceLineEdited:(NSNotification*)notification;

@end
