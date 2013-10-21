#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>
#import "ManagedModel.h"
#import "Contact.h"

@class Conference;
@class ConferenceLine;
@class Contact;


enum {
    DONT_REPEAT = 0,
    DAILY = 1,
    WEEKLY =  2,
    BIWEEKLY = 3,
    MONTHLY = 4
}REPEAT_TYPES;

enum {
    DONT_NOTIFY =  0,
    MINS_15 = 1,
    MINS_30 = 2,
    HRS_1 = 3,
    DAYS_1 = 4
}NOTIFY_TYPES;

@interface Conference : ManagedModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * notify;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * addToCalID;
@property (nonatomic, retain) NSString * notifyID;
@property (nonatomic, retain) NSNumber * addToCal;
@property (nonatomic, retain) ConferenceLine *conferenceLine;
@property (nonatomic, retain) NSOrderedSet *moderators;
@property (nonatomic, retain) NSOrderedSet *participants;
@property (nonatomic, retain) NSNumber *isOwnerModerator;
@property (nonatomic, retain) NSNumber *isOwnerParticipant;

+(NSArray *) conferencesToday;
+(NSArray *) conferencesThisMonth;
+(NSString *) stringFromDate:(NSDate *)date;
+(NSString *) stringFromInterval:(NSDate *)start to:(NSDate *)end;

+(NSString *) stringForNotify:(int)notice;
+(NSString *) stringForRepeatType:(int)interval;

+(NSString *) stringForParticipantsInConference:(Conference *)conference;
+(void)addConferencesToCalendar:(EKEventStore *) eventStore;

+(void) scheduleConferenceNotifications;
+(void) updateAllConferenceDates;


-(NSString *) dateString;
-(NSString *) monthDayYearString;
-(NSString *) timeString;

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

@end
