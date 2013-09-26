#import <UIKit/UIKit.h>

#import "Conference.h"
#import "Constants.h"
#import "SingleImageLeftTitleAndSubTitleCell.h"
#import "ConferenceDetailViewController.h"
#import "ListConferenceLinesViewController.h"
@interface ListConferencesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)IBOutlet UILabel *noConferencesLabel;
@property(nonatomic, strong)IBOutlet UIButton *createConferenceButton;
@property(nonatomic, strong)IBOutlet UIImageView *background;
@property(nonatomic, strong)IBOutlet UITableView *table;
@property(nonatomic, strong)IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIImage *cellImage;

@property(nonatomic, strong) NSArray *conferences;

-(IBAction)createConferencePressed;
-(IBAction)segmentedControlToggle:(id)sender;

-(void)conferencesModified:(NSNotification *)notification;

@end
