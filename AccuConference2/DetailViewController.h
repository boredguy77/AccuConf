//
//  DetailViewController.h
//  AccuConference2
//
//  Created by Alex Telford on 8/24/13.
//  Copyright (c) 2013 Alex Telford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
