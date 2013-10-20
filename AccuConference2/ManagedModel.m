#import "ManagedModel.h"

@implementation ManagedModel

static NSManagedObjectContext *managedObjectContextRef = nil;
static NSEntityDescription *entity = nil;
static NSNotificationCenter *defaultCenter = nil;
static NSString *modelName = @"ManagedModel";

@synthesize managed, selected;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self) {
        selected = NO;
        managed = context!=nil;
    }
    return self;
}

-(void)clone:(ManagedModel *)managedModelToCopy{

}

+(NSString *)modelName{
    return modelName;
}

+(NSEntityDescription *)entity{
    return entity;
}

+(NSManagedObjectContext *)managedObjectContextRef{
    return managedObjectContextRef;
}

+(void)save:(ManagedModel *)managedModel{
    NSLog(@"save %@s", [[self class] modelName]);
    NSError *err;
    [managedObjectContextRef save:&err];
    [[self class] dispatchAll];
}

+(ManagedModel *)instance:(BOOL)managed{
    NSLog(@"instance %@ : managed : %@", [[self class] modelName], managed?@"YES":@"NO");
    NSManagedObjectContext *moc = nil;
    if (managed) {
        moc = managedObjectContextRef;
    }
    return [[[self class] alloc] initWithEntity:[[self class]entity] insertIntoManagedObjectContext:moc];
}

+(void)setManagedObjectcontextRef:(NSManagedObjectContext *)moc{
    defaultCenter = [NSNotificationCenter defaultCenter];
    managedObjectContextRef = moc;
    [[self class] setEntity:[NSEntityDescription entityForName:[[self class] modelName] inManagedObjectContext:managedObjectContextRef ]];
}

+(void)setEntity:(NSEntityDescription *)ety{
    entity = ety;
}

+(NSArray *)all{
    NSLog(@"all %@s", [[self class] modelName]);
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [[self class] entity];
    NSError *error;
    NSArray *objects = [managedObjectContextRef executeFetchRequest:fetch error:&error];
    return objects;
}

+(ManagedModel *)insert:(ManagedModel *)unmanagedModel{
    NSLog(@"insert %@ : %@", [[self class] modelName], unmanagedModel);
    ManagedModel *model = (ManagedModel *) [NSEntityDescription insertNewObjectForEntityForName:[[self class] modelName] inManagedObjectContext:managedObjectContextRef];
        [model clone:unmanagedModel];
    
    [[self class] save:nil];
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:model, [[self class] modelName], nil];
    NSString *notificationName = [NSString stringWithFormat:@"%@_INSERTED",[[[self class] modelName] uppercaseString]];
    [defaultCenter postNotificationName:notificationName object:self userInfo:retDict];
    [self dispatchAll];
    return model;
}

+(ManagedModel *)update:(ManagedModel *)managedModel{
    NSLog(@"update %@ : %@", [[self class] modelName], managedModel);
    [[self class] save:nil];
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:managedModel, [[self class] modelName], nil];
    NSString *notificationName = [NSString stringWithFormat:@"%@_UPDATED",[[[self class] modelName] uppercaseString]];
    [defaultCenter postNotificationName:notificationName object:self userInfo:retDict];
    [[self class]dispatchAll];
    return managedModel;
}

+(ManagedModel *)remove:(ManagedModel *)managedModel{
    NSLog(@"delete %@ : %@", [[self class] modelName], managedModel);
    [managedObjectContextRef deleteObject:managedModel];
    
    [[self class] save:nil];
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:managedModel, [[self class] modelName], nil];
    NSString *notificationName = [NSString stringWithFormat:@"%@_DELETED",[[[self class] modelName] uppercaseString]];
    NSLog(@"%@",notificationName);
    [defaultCenter postNotificationName:notificationName object:managedModel userInfo:retDict];
    [[self class]dispatchAll];
    return managedModel;
}

+(BOOL)validate:(ManagedModel *)managedModel{
    return managedModel != nil && [managedModel isMemberOfClass:[self class]];
}

+(void)dispatchAll{
    NSLog(@"dispatchAll %@s", [[self class] modelName]);
    NSArray *objects = [[self class ]all];
    NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:objects, [NSString stringWithFormat:@"%@",[[self class] modelName]], nil];
    NSString *notificationName = [NSString stringWithFormat:@"%@S_MODIFIED",[[[self class] modelName] uppercaseString]];
    NSLog(@"notificationName %@", notificationName);
    [defaultCenter postNotificationName:notificationName object:self userInfo:retDict];
}

@end
