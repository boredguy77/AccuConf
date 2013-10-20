#import <UIKit/UIKit.h>
#import "Conference.h"
#import "ListConferenceContactsViewController.h"
#import "ConferenceLine.h"

@interface AddEditConferenceViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    UIImage *radioImage;
    UIImage *radioPressedImage;
    NSArray *radioArray;
    NSLayoutConstraint *deleteButtonConstraint;
    BOOL startImmediately;
    NSDate *startDate, *endDate;
    UITextField *selectedTextField;
    UILabel *selectedLabel;
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
@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property(nonatomic, strong) IBOutlet UIView *datePickerView;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollview;
@property(nonatomic, strong) IBOutlet UIView *pickerView;
@property(nonatomic, strong) IBOutlet UIPickerView *picker;
@property BOOL isDatePickerShowing;
@property BOOL isDeleteShowing;
@property BOOL isPickerShowing;

-(IBAction)startImmediatelyButtonPressed;
-(IBAction)scheduleButtonPressed;
-(IBAction)nextButtonPressed;
-(IBAction)deleteButtonPressed;
-(IBAction)dateFieldPressed:(id)sender;
-(IBAction)datePickerDonePressed;
-(IBAction)pickerDonePressed;
-(IBAction)pickerFieldPressed:(id)sender;

@end
