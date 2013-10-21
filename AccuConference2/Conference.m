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
        if (conference.notify.intValue != 0) {
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

+(void)addConferencesToCalendar:(EKEventStore *)eventStore{
    NSLog(@"add Conferences to calendar");
    NSArray *all = [self all];
    for (Conference *conference in all) {
        NSLog(@"checking %@ %@", conference.name, conference.addToCal.boolValue?@"YES":@"NO");
        if(conference.addToCal.boolValue){
            NSLog(@"adding conference %@", conference.name);
            NSError *err;
            
            EKEvent *conferenceEvent = [eventStore eventWithIdentifier:conference.addToCalID];
            EKRecurrenceRule *recurrenceRule;
            
            
            if(!conferenceEvent){
                conferenceEvent  = [EKEvent eventWithEventStore:eventStore];
            }
            
            conferenceEvent.title = [NSString stringWithFormat:@"%@ conference call", conference.name];
            conferenceEvent.notes = [NSString stringWithFormat:@"Conference Name : %@ Date : %@", conference.name, [self stringFromDate:conference.startTime]];
            
            
            EKAlarm *alarm;
            
            switch (conference.notify.intValue) {
                case 1:
                    alarm =[EKAlarm alarmWithRelativeOffset:-900];
                    break;
                case 2:
                    alarm =[EKAlarm alarmWithRelativeOffset:-1800];
                    break;
                case 3:
                    alarm =[EKAlarm alarmWithRelativeOffset:-3600];
                    break;
                case 4:
                    alarm =[EKAlarm alarmWithRelativeOffset:-86400];
                    break;
            }
            
            if(alarm) {
                [conferenceEvent addAlarm:alarm];
            }
            
            conferenceEvent.startDate = conference.startTime;
            conferenceEvent.endDate = conference.endTime;
            
            switch (conference.repeat.intValue) {
                case 1:
                    recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:Nil];
                    break;
                case 2:
                    recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:Nil];
                    break;
                case 3:
                    recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:2 end:Nil];
                    break;
                case 4:
                    recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:Nil];
                    break;
                    
                default:
                    break;
            }
            if (recurrenceRule) {
                [conferenceEvent addRecurrenceRule:recurrenceRule];
            }
            
            [conferenceEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
            
            [eventStore saveEvent:conferenceEvent span:EKSpanThisEvent error:&err];
            if (err) {
                NSLog(@"Error");
            }
            conference.addToCalID = conferenceEvent.eventIdentifier;
        }
    }
}

+(void)updateAllConferenceDates{
    NSLog(@"updateAllConferenceDates");
    NSArray *all = [Conference all];
    NSDate *now = [NSDate date];
    for (Conference *conference in all) {
        NSLog(@"Conference Start time : %@ now %@", conference.startTime, now);
        if ([conference.startTime timeIntervalSinceDate:now] < 0 && conference.repeat.intValue != 0) {
            NSLog(@"date is older");
            int duration = [conference.endTime timeIntervalSinceDate:conference.startTime];
            int interval = 0 ;
            switch (conference.repeat.intValue) {
                case 1:
                    interval = 86400;
                    break;
                case 2:
                    interval = 86400 * 7;
                    break;
                case 3:
                    interval = 1209600;
                    break;
                case 4:
                    interval = 2629743.83;
                    break;
            }
            NSDate *newDate = conference.startTime;
            do {
                NSLog(@"setting new date");
                newDate = [newDate dateByAddingTimeInterval:interval];
            } while (newDate < now);
            conference.startTime = newDate;
            conference.endTime = [newDate dateByAddingTimeInterval:duration];
        }
    }
    [super dispatchAll];
    [self save:nil];
}


@end
