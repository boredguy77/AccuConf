#import "Contact.h"
#import "Conference.h"

static NSEntityDescription *entity = nil;
static NSString *modelName = @"Contact";

@implementation Contact

@dynamic fName;
@dynamic lName;
@dynamic email;
@dynamic phone;
@dynamic addToPhone;
@dynamic groups;
@dynamic moderatorConferences;
@dynamic participantConferences;
@dynamic recordID;
@dynamic ownerContact;

-(void)clone:(Contact *)contactToCopy{
    self.fName = contactToCopy.fName;
    self.lName = contactToCopy.lName;
    self.email = contactToCopy.email;
    self.phone = contactToCopy.phone;
    self.recordID = contactToCopy.recordID;
}

+(Contact *)contactForRecordID:(NSInteger )rcrdID{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:[super managedObjectContextRef]];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %i", rcrdID];
    fetch.entity = ed;
    fetch.predicate = predicate;
    NSError *error;
    NSArray *groups = [[super managedObjectContextRef] executeFetchRequest:fetch error:&error];
    
    Contact *retContact = nil;
    if(groups.count > 0){
        retContact = (Contact *) [groups objectAtIndex:0];
    }
    
    return retContact;
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

+(Contact *) ownerContact{
    NSManagedObjectContext *context = [super managedObjectContextRef];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Contact" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ownerContact==%@",[NSNumber numberWithBool:YES]];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    Contact *contact = (Contact *) [array firstObject];
    if(!contact){
        contact = (Contact *)[Contact instance:YES];
        contact.ownerContact = [NSNumber numberWithBool:YES];
        contact.fName = @"(You)";
        contact.lName = @" ";
        [Contact save:contact];
    }
    
    return contact;
}

@end
