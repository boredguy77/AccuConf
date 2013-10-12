#import "Conference.h"

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

-(NSString *) monthDayYearString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"EEE MM/dd/YY"];
	NSString *dateString = [formatter stringFromDate:self.startTime];
    if (dateString==nil) {
        dateString=@"No Date";
    }
	return dateString;
}

-(NSString *) timeString{
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

@end
