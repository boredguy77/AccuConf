#import "Group.h"
#import "Contact.h"


static NSEntityDescription *entity = nil;
static NSString *modelName = @"Group";

@implementation Group

@dynamic name;
@dynamic contacts;

-(void)clone:(Group *)modelGroup{
    self.name = modelGroup.name;
    if (self.managedObjectContext == modelGroup.managedObjectContext){
        self.contacts = [NSSet setWithSet:modelGroup.contacts];
    } else {
        @throw @"contexts dont match";
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

@end
