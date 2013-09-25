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

@end
