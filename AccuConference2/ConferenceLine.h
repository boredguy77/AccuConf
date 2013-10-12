#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedModel.h"


@interface ConferenceLine : ManagedModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSString * participantCode;
@property (nonatomic, retain) NSString * moderatorCode;
@property (nonatomic, retain) NSOrderedSet *conferences;


@end

@interface ConferenceLine (CoreDataGeneratedAccessors)

- (void)addConferencesObject:(NSManagedObject *)value;
- (void)removeConferencesObject:(NSManagedObject *)value;
- (void)addConferences:(NSSet *)values;
- (void)removeConferences:(NSSet *)values;
- (NSString *)numberToURL;

@end
