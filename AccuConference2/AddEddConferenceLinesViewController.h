#import <UIKit/UIKit.h>
#import "ConferenceLine.h"
#import "Constants.h"
#import "ParentViewController.h"
@interface AddEddConferenceLinesViewController : ParentViewController
@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *number;
@property(nonatomic, strong) IBOutlet UITextField *suffix;
@property(nonatomic, strong) IBOutlet UITextField *participantCode;
@property(nonatomic, strong) IBOutlet UITextField *moderatorCode;
@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong) ConferenceLine *conferenceLine;

-(IBAction)saveButtonPressed;
-(IBAction)deleteButtonPressed;

@end
