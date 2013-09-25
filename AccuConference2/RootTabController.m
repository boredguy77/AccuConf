#import "RootTabController.h"

@implementation RootTabController
@synthesize calendarTabController,callTabController,contactsTabController, infoTabController;

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    callTabController = (UINavigationController *) [self.viewControllers objectAtIndex:0];
    calendarTabController = (UINavigationController *) [self.viewControllers objectAtIndex:1];
    contactsTabController = (UINavigationController *) [self.viewControllers objectAtIndex:2];
    infoTabController = (UINavigationController *) [self.viewControllers objectAtIndex:3];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}


@end
