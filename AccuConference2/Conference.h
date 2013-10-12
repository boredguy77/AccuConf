#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedModel.h"

@class Conference;
@class ConferenceLine;
@class Contact;

@interface Conference : ManagedModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * notify;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * addToCal;
@property (nonatomic, retain) ConferenceLine *conferenceLine;
@property (nonatomic, retain) NSOrderedSet *moderators;
@property (nonatomic, retain) NSOrderedSet *participants;

@end

@interface Conference (CoreDataGeneratedAccessors)

- (void)addModeratorsObject:(NSManagedObject *)value;
- (void)removeModeratorsObject:(NSManagedObject *)value;
- (void)addModerators:(NSOrderedSet *)values;
- (void)removeModerators:(NSOrderedSet *)values;

- (void)addParticipantsObject:(NSManagedObject *)value;
- (void)removeParticipantsObject:(NSManagedObject *)value;
- (void)addParticipants:(NSOrderedSet *)values;
- (void)removeParticipants:(NSOrderedSet *)values;

-(NSString *)dateString;
-(NSString *) monthDayYearString;
-(NSString *) timeString;

@end
