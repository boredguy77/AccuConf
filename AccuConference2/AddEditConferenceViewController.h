#import <UIKit/UIKit.h>
#import "Conference.h"
#import "ListConferenceContactsViewController.h"
#import "ConferenceLine.h"

@interface AddEditConferenceViewController : UIViewController {
    UIImage *radioImage;
    UIImage *radioPressedImage;
    NSArray *radioArray;
}

@property (nonatomic, strong) Conference *conference;
@property (nonatomic, strong) ConferenceLine *conferenceLine;

@property(nonatomic, strong) IBOutlet UILabel *conferenceLineNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineNumberLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineModeratorCodeLabel;
@property(nonatomic, strong) IBOutlet UILabel *conferenceLineParticipantCodeLabel;

@property(nonatomic, strong) IBOutlet UITextField *nameField;
@property(nonatomic, strong) IBOutlet UITextField *notesField;
@property(nonatomic, strong) IBOutlet UITextField *startTimeField;
@property(nonatomic, strong) IBOutlet UITextField *endTimeField;
@property(nonatomic, strong) IBOutlet UIButton *immediateConferenceButton;
@property(nonatomic, strong) IBOutlet UIButton *scheduleConferenceButton;
@property(nonatomic, strong) IBOutlet UISwitch *addToCalSwitch;
@property(nonatomic, strong) IBOutlet UILabel *repeatLabel;
@property(nonatomic, strong) IBOutlet UILabel *notifyLabel;
@property(nonatomic, strong) IBOutlet UIView *scheduleView;

-(IBAction)startButtonPressed;
-(IBAction)scheduleButtonPressed;
-(IBAction)nextButtonPressed;

@end
