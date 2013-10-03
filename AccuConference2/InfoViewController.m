#import "InfoViewController.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(void)callAccuConference{
    //1800 977 4607
    NSURL *url = [NSURL URLWithString:@"tel:18009774607"];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)emailAccuConference{
    //iphone@accuconference.com
    NSURL *url = [NSURL URLWithString:@"mailto:iphone@accuconference.com"];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)webAccuConference{
    NSURL *url = [NSURL URLWithString:@"http://www.accuconference.com"];
    [[UIApplication sharedApplication] openURL:url];
}


@end
