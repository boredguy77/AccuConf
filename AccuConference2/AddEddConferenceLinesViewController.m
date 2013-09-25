#import "AddEddConferenceLinesViewController.h"

@implementation AddEddConferenceLinesViewController
@synthesize conferenceLine, name, number, suffix, participantCode, moderatorCode, deleteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.conferenceLine){
        [self populateUIWithConferenceLine:self.conferenceLine];
        self.deleteButton.hidden = NO;
    } else {
        self.title = @"Add New Line";
        self.deleteButton.hidden = YES;
    }
}

-(void)populateUIWithConferenceLine:(ConferenceLine *)line{
    self.title = @"Edit Line";
    self.name.text = line.name;
    self.number.text = line.number;
    self.moderatorCode.text = line.participantCode;
    self.participantCode.text = line.moderatorCode;
    self.suffix.text = line.suffix;
}

-(void)clearUIValues{
    self.title = @"";
    self.name.text = @"";
    self.number.text = @"";
    self.moderatorCode.text = @"";
    self.participantCode.text = @"";
    self.suffix.text = @"";
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isConferenceValuesValid{
#warning implement
    return YES;
}

-(ConferenceLine *)populateFomUI:(ConferenceLine *)line{
    line.name = self.name.text;
    line.number = self.number.text;
    line.suffix = self.suffix.text;
    line.participantCode = self.participantCode.text;
    line.moderatorCode = self.moderatorCode.text;
    return line;
}

#pragma mark - IBAction
-(void)saveButtonPressed{
    if([self isConferenceValuesValid]){
        if(!self.conferenceLine){
            self.conferenceLine = (ConferenceLine *) [ConferenceLine instance:YES];
        }
        [self populateFomUI:self.conferenceLine];
        [ConferenceLine save:self.conferenceLine];
        [self clearUIValues];
        self.conferenceLine = nil;
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Conference Line" message:@"One or more of the values entered for the conference line is invalid." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)deleteButtonPressed{
    [ConferenceLine remove:self.conferenceLine];
    [self clearUIValues];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.conferenceLine = nil;
}

@end
