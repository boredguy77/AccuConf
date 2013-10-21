#import <CoreData/CoreData.h>

@interface ManagedModel : NSManagedObject
@property BOOL managed;
@property BOOL selected;

-(void)clone:(ManagedModel *)modelToCopy;

+(NSArray *)all;
+(void)dispatchAll;
+(ManagedModel *)insert:(ManagedModel *)unmanagedModel;
+(void)save:(ManagedModel *)managedModel;
+(ManagedModel *)update:(ManagedModel *)managedModel;
+(ManagedModel *)remove:(ManagedModel *)managedModel;
+(ManagedModel *)instance:(BOOL)managedModel;

+(NSString *)modelName;
+(NSEntityDescription *)entity;
+(NSManagedObjectContext *)managedObjectContextRef;
+(void)setEntity:(NSEntityDescription *)entity;
+(BOOL)validate:(ManagedModel *)managedModel;

+(void)setManagedObjectcontextRef:(NSManagedObjectContext *)moc;

@end
