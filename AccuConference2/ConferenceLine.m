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
@end
