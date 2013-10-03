#import <UIKit/UIKit.h>
#import "ConferenceLine.h"
#import "Conference.h"
#import "SingleImageLeftSingleLineTextCell.h"
#import "ConferenceLineDetailViewController.h"
#import "AddEditConferenceViewController.h"
#import "ParentViewController.h"
#import "Constants.h"

@protocol ListConferenceLinesDelegate;

@interface ListConferenceLinesViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) IBOutlet UIImageView *background;
@property(nonatomic, strong) IBOutlet UIButton *setupLineButton;
@property(nonatomic, strong) IBOutlet UILabel *noConferenceLinesLabel;

@property(nonatomic, strong) NSArray *conferenceLines;

@property(nonatomic, weak) id<ListConferenceLinesDelegate> delegate;
@property int mode;

-(IBAction)addButtonPress;
-(void)conferenceLinesModified:(NSNotification *) notification;
-(void)hideNoConferenceLinesNotification;
-(void)showNoConferenceLinesNotification;
-(void)hideConferenceLinesTable;
-(void)showConferenceLinesTable;

@end

@protocol ListConferenceLinesDelegate <NSObject>

@required
-(void)didSelectConferenceLine:(ConferenceLine *)line;

@end
