//
//  MasterViewController.h
//  AccuConference2
//
//  Created by Alex Telford on 8/24/13.
//  Copyright (c) 2013 Alex Telford. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
