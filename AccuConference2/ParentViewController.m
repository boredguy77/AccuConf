#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(void)unFocusKeyboard{
    [self.view resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"unFocusKeyboard");
}

@end