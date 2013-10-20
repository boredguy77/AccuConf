#import "ConferenceLine.h"

@implementation ConferenceLine

static NSEntityDescription *entity = nil;
static NSString *modelName = @"ConferenceLine";

@dynamic name;
@dynamic number;
@dynamic suffix;
@dynamic participantCode;
@dynamic moderatorCode;
@dynamic conferences;

+(void)save:(ManagedModel *)managedModel{
    [super save:managedModel];
    ConferenceLine *line = (ConferenceLine *) managedModel;
    NSLog(@"save %@", line.name);
}

-(void)clone:(ConferenceLine *)lineToCopy{
    self.name = lineToCopy.name;
    self.number = lineToCopy.number;
    self.suffix = lineToCopy.suffix;
    self.participantCode = lineToCopy.participantCode;
    self.moderatorCode = lineToCopy.moderatorCode;
    self.conferences = lineToCopy.conferences;
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

-(NSString *)numberToURL{
    NSString *tmpNumber, *tmpCode, *tmpSuffix;
    if (!self.number){
        tmpNumber = @"";
    } else {
        tmpNumber = self.number;
    }
    
    if(self.moderatorCode && ![self.moderatorCode isEqualToString:@""]){
        tmpCode = self.moderatorCode;
    } else if(!self.participantCode){
        tmpCode = self.participantCode;
    } else {
        tmpCode = @"";
    }
    
    if (!self.suffix) {
        tmpSuffix = @"";
    } else {
        tmpSuffix = self.suffix;
    }
    
    return [NSString stringWithFormat:@"tel:%@,%@,%@",tmpNumber,tmpCode,tmpSuffix];
}

+(NSString *)scrubPhoneNumber:(NSString *)phoneNumberToScrub{
    NSMutableString *strippedString = [[NSMutableString alloc] init];
    for (int i=0; i<[phoneNumberToScrub length]; i++) {
        if (isdigit([phoneNumberToScrub characterAtIndex:i])) {
            [strippedString appendFormat:@"%c",[phoneNumberToScrub characterAtIndex:i]];
        }
    }
    
    return strippedString;
    
}

+(NSString *)formatStringAsPhoneNumber:(NSString *)number{
	NSMutableString *tmpNumber = [[NSMutableString alloc]initWithString:number];
	switch ([tmpNumber length]) {
		case 10: number = [NSString stringWithFormat:@"%c%c%c.%c%c%c.%c%c%c%c",[tmpNumber characterAtIndex:0],[tmpNumber characterAtIndex:1],[tmpNumber characterAtIndex:2],[tmpNumber characterAtIndex:3],[tmpNumber characterAtIndex:4],[tmpNumber characterAtIndex:5],[tmpNumber characterAtIndex:6],[tmpNumber characterAtIndex:7],[tmpNumber characterAtIndex:8],[tmpNumber characterAtIndex:9]];
			break;
        case 11: number = [NSString stringWithFormat:@"%c.%c%c%c.%c%c%c.%c%c%c%c",[tmpNumber characterAtIndex:0],[tmpNumber characterAtIndex:1],[tmpNumber characterAtIndex:2],[tmpNumber characterAtIndex:3],[tmpNumber characterAtIndex:4],[tmpNumber characterAtIndex:5],[tmpNumber characterAtIndex:6],[tmpNumber characterAtIndex:7],[tmpNumber characterAtIndex:8],[tmpNumber characterAtIndex:9],[tmpNumber characterAtIndex:10]];
			break;
		case 13: number = [NSString stringWithFormat:@"%c%c%c.%c%c%c.%c%c%c.%c%c%c%c",[tmpNumber characterAtIndex:0],[tmpNumber characterAtIndex:1],[tmpNumber characterAtIndex:2],[tmpNumber characterAtIndex:3],[tmpNumber characterAtIndex:4],[tmpNumber characterAtIndex:5],[tmpNumber characterAtIndex:6],[tmpNumber characterAtIndex:7],[tmpNumber characterAtIndex:8],[tmpNumber characterAtIndex:9],[tmpNumber characterAtIndex:10],[tmpNumber characterAtIndex:11],[tmpNumber characterAtIndex:12]];
			break;
        case 14: number = [NSString stringWithFormat:@"%c.%c%c%c.%c%c%c.%c%c%c.%c%c%c%c",[tmpNumber characterAtIndex:0],[tmpNumber characterAtIndex:1],[tmpNumber characterAtIndex:2],[tmpNumber characterAtIndex:3],[tmpNumber characterAtIndex:4],[tmpNumber characterAtIndex:5],[tmpNumber characterAtIndex:6],[tmpNumber characterAtIndex:7],[tmpNumber characterAtIndex:8],[tmpNumber characterAtIndex:9],[tmpNumber characterAtIndex:10],[tmpNumber characterAtIndex:11],[tmpNumber characterAtIndex:12],[tmpNumber characterAtIndex:13]];
			break;
	}
	return number;
}

+(BOOL)validate:(ManagedModel *)managedModel{
    if ([super validate:managedModel]) {
        ConferenceLine *conferenceLine = (ConferenceLine *) managedModel;
        if (![conferenceLine.number isEqualToString:@""] && ![conferenceLine.name isEqualToString:@""]) {
            return YES;
        }
    }
    return NO;
}
@end
