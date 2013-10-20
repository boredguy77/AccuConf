#import "Conference.h"
#import <EventKit/EventKit.h>

static NSEntityDescription *entity = nil;
static NSString *modelName = @"Conference";

@implementation Conference

@dynamic name;
@dynamic notify;
@dynamic repeat;
@dynamic endTime;
@dynamic startTime;
@dynamic notes;
@dynamic addToCal;
@dynamic conferenceLine;
@dynamic moderators;
@dynamic participants;
@dynamic addToCalID;
@dynamic notifyID;
@dynamic isOwnerModerator;
@dynamic isOwnerParticipant;

-(void)clone:(Conference *)conferenceToCopy{
    self.name = conferenceToCopy.name;
    self.notify = conferenceToCopy.notify;
    self.repeat = conferenceToCopy.repeat;
    self.endTime = conferenceToCopy.endTime;
    self.startTime = conferenceToCopy.startTime;
    self.notes = conferenceToCopy.notes;
    self.addToCal = conferenceToCopy.addToCal;
    self.moderators = conferenceToCopy.moderators;
    
    for (Contact *contact in conferenceToCopy.moderators) {
      [self addModeratorsObject:contact];
    }
    
    for (Contact *contact in conferenceToCopy.participants) {
        [self addParticipantsObject:contact];
    }
}

+(NSString *)modelName{
    return modelName;
}

+(NSEntityDescription *)entity{
    return entity;
}

+(void)setEntity:(NSEntityDescription *)ety{
    entity = ety;
}

+(NSString *)stringFromDate:(NSDate *)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"hh:mm a ' ' EEE MM/dd/YY"];
	NSString *dateString = [formatter stringFromDate:date];
    if (dateString==nil) {
        dateString=@"No Date";
    }
	return dateString;
}

+(NSString *)stringFromInterval:(NSDate *)start to:(NSDate *)end{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.PMSymbol = @"pm";
    df.AMSymbol = @"am";
    df.dateFormat = @"MMM d, hh:mma";
    NSString *firstString = [df stringFromDate:start];
    
    df.dateFormat = @"hh:mma";
    NSString *secondString = [df stringFromDate:end];
    
    NSString *retString = [NSString stringWithFormat:@"%@-%@",firstString, secondString];
    return retString;
}

-(NSString *)getEndDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"hh:mm a ' ' EEE MM/dd/YY"];
	NSString *dateString = [formatter stringFromDate:self.endTime];
    if (dateString==nil) {
        dateString=@"No Date";
    }
	return dateString;
}

-(NSString *)dateString{
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"hh:mm a ' ' EEE MM/dd/YY"];
	NSString *dateString = [formatter stringFromDate:self.startTime];
    if (dateString==nil) {
        dateString=@"No Date";
    }
	return dateString;
}

-(NSString *)monthDayYearString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"EEE MM/dd/YY"];
	NSString *dateString = [formatter stringFromDate:self.startTime];
    if (dateString==nil) {
        dateString=@"No Date";
    }
	return dateString;
}

-(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //	[formatter setDateFormat:@"hh:mm a"];
    
    formatter.PMSymbol = @"pm";
    formatter.AMSymbol = @"am";
    
	[formatter setDateFormat:@"hh:mma"];
	NSString *dateString = [formatter stringFromDate:self.startTime];
    
    NSTimeZone *time = [NSTimeZone localTimeZone];
//    NSString *abbr = [time abbreviation];
    
    if (dateString==nil) {
        dateString=@"No Date";
    }
//    else dateString = [dateString stringByAppendingFormat:@" %@",abbr];
	return dateString;
}

+(NSArray *)conferencesToday{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit fromDate:today];
    NSManagedObjectContext *moc = [ManagedModel managedObjectContextRef];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *endDate = [calendar dateFromComponents:components];
    NSLog(@"today between %@ and %@",startDate, endDate);
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Conference" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startTime >= %@) AND (startTime <= %@)", startDate, endDate];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"startTime" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return array;
}

+(NSArray *)conferencesThisMonth{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:today];
    NSManagedObjectContext *moc = [ManagedModel managedObjectContextRef];
    
    [components setSecond:0];
    [components setMinute:0];
    [components setHour:0];
    [components setDay:0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    [components setSecond:0];
    [components setMinute:0];
    [components setHour:0];
    [components setDay:0];
    [components setMonth:components.month + 1];
    
    NSDate *endDate = [calendar dateFromComponents:components];
    NSLog(@"between %@ and %@",startDate, endDate);
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Conference" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startTime >= %@) AND (startTime <= %@)", startDate, endDate];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"startTime" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return array;
}

+(NSString *)stringForRepeatType:(int)notice{
    switch (notice) {
        case DONT_REPEAT:
            return @"Never";
            break;
        case DAILY:
            return @"Daily";
            break;
        case WEEKLY:
            return @"Weekly";
            break;
        case BIWEEKLY:
            return @"Biweekly";
            break;
        case MONTHLY:
            return @"Monthly";
            break;
            
        default:
            return @"";
            break;
    }
}

+(NSString *)stringForNotify:(int)interval{
    switch (interval) {
        case DONT_NOTIFY:
            return @"None";
            break;
        case MINS_15:
            return @"15 Mins before";
            break;
        case MINS_30:
            return @"30 Mins before";
            break;
        case HRS_1:
            return @"1 Hour before";
            break;
        case DAYS_1:
            return @"1 Day before";
            break;
            
        default:
            return @"";
            break;
    }
}

+(void)scheduleConferenceNotifications{
    NSArray *all = [self all];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (Conference *conference in all) {
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        
        NSDate *fireDate = conference.startTime;
        
        switch (conference.notify.intValue) {
            case 1:
                fireDate = [fireDate dateByAddingTimeInterval:-900];
                break;
            case 2:
                fireDate = [fireDate dateByAddingTimeInterval:-1800];
                break;
            case 3:
                fireDate = [fireDate dateByAddingTimeInterval:-3600];
                break;
            case 4:
                fireDate = [fireDate dateByAddingTimeInterval:-86400];
                break;
        }
        
        notification.fireDate = conference.startTime;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = [NSString stringWithFormat:@"conference call reminder : %@",conference.name];
        notification.alertAction = @"AccuDial Reminder";
        notification.soundName = UILocalNotificationDefaultSoundName;

        switch (conference.repeat.intValue) {
            case 1:
                notification.repeatInterval = NSDayCalendarUnit;
                break;
            case 2:
                notification.repeatInterval = NSWeekCalendarUnit;
                break;
            case 3:
                notification.repeatInterval = NSWeekCalendarUnit;
                break;
            case 4:
                notification.repeatInterval = NSMonthCalendarUnit;
                break;
        }
        NSLog(@"Schedule conference for : %@", fireDate);
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+(BOOL)addConferenceToCalendar:(Conference *)conference{
#warning finish fleshing out addToCalendar
//    EKEventStore *eventStore = [[EKEventStore alloc] init];
//    NSError *err;
    
//    EKEvent *conferenceEvent = [eventStore eventWithIdentifier:conference.addToCalID];
    
//    if(conferenceEvent!=nil){
//        if(conference.startTime){
//            conferenceEvent.startDate = conference.startTime;
//            conferenceEvent.endDate = conference.endTime;
////            conferenceEvent.recurrenceRules =
//            [eventStore saveEvent:conferenceEvent span:EKSpanThisEvent error:&err];
//            return YES;
//        }
//        else {
//            [eventStore removeEvent:conferenceEvent span:EKSpanThisEvent error:&err ];
//            return YES;
//        }
//    }
//    else{
//        if(self.unSavedConferenceCall.conferenceDate!=nil){
//            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
//            event.title = [NSString stringWithFormat:@"%@ conference call", self.unSavedConferenceCall.name];
//            event.notes = [NSString stringWithFormat:@"Conference Name : %@ Date : %@",self.unSavedConferenceCall.name, [self.unSavedConferenceCall getDateString]];
//            event.startDate = self.unSavedConferenceCall.conferenceDate;
//            event.endDate = self.unSavedConferenceCall.conferenceEndDate;
//            
//            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-900];
//            [event addAlarm:alarm];
//            
//            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//            
//            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
//            [eventStore release];
//            if (err) {
//                NSLog(@"Error");
//                return NO;
//            }
//            self.unSavedConferenceCall.calendarEventID = event.eventIdentifier;
//            return YES;
//        }
//        else return NO;
//    }
    return NO;
}

+(NSString *)stringForParticipantsInConference:(Conference *)conference{
    NSMutableString *retString = [NSMutableString string];
    for (Contact *contact in conference.moderators) {
        [retString appendFormat:@"<b>%@:</b> Moderator <br />",contact.fName];
    }
    
    for (Contact *contact in conference.participants) {
        [retString appendFormat:@"<b>%@</b> (Participant) <br />",contact.fName];
    }
    return retString;
}

+(BOOL)validate:(ManagedModel *)managedModel{
    if ([super validate:managedModel]) {
        Conference *conference = (Conference *) managedModel;
        if (conference.conferenceLine && ![conference.name isEqualToString:@""] && conference.startTime && conference.endTime) {
            return YES;
        }
    }
    return NO;
}

+(void)save:(ManagedModel *)managedModel{
    [super save:managedModel];
    [self scheduleConferenceNotifications];
}


@end
