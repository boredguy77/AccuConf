#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedModel.h"

@class Conference;
@class Group;

@interface Contact : ManagedModel

@property (nonatomic, retain) NSString * fName;
@property (nonatomic, retain) NSString * lName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * addToPhone;
@property (nonatomic, retain) NSNumber * ownerContact;
@property (nonatomic, retain) NSOrderedSet *groups;
@property (nonatomic, retain) Conference *moderatorConferences;
@property (nonatomic, retain) Conference *participantConferences;
@property (nonatomic, retain) NSNumber * recordID;

+(Contact *)contactForRecordID:(NSInteger)id;

+(Contact *) ownerContact;

@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(NSManagedObject *)value;
- (void)removeGroupsObject:(NSManagedObject *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
