#import <UIKit/UIKit.h>
#import "Conference.h"
#import "ConferenceLine.h"
#import "AddEditConferenceViewController.h"
@interface ConferenceDetailViewController : UITableViewController

@property(nonatomic, strong)Conference *conference;

@property(nonatomic, strong) IBOutlet UILabel *conferenceLineNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineNumberLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineModeratorCodeLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineParticipantCodeLabel;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *notesLabel;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UILabel *repeatLabel;
@property(nonatomic, strong) IBOutlet UILabel *notifyLabel;
@property(nonatomic, strong) IBOutlet UILabel *addToCalendarLabel;

@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UIWebView *contactWebView;

-(IBAction)editButtonPressed;


@end
