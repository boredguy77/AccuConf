#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ManagedModel.h"

@class Contact;

@interface Group : ManagedModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *contacts;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
