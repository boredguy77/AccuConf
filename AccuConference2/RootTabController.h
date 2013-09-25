#import <UIKit/UIKit.h>

@interface RootTabController : UITabBarController <UITabBarControllerDelegate>

@property(nonatomic, strong) IBOutlet UINavigationController *callTabController;
@property(nonatomic, strong) IBOutlet UINavigationController *calendarTabController;
@property(nonatomic, strong) IBOutlet UINavigationController *contactsTabController;
@property(nonatomic, strong) IBOutlet UINavigationController *infoTabController;


@end
