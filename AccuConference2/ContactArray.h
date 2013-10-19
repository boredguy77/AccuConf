#import <Foundation/Foundation.h>
#import "Contact.h"

@interface ContactArray : NSObject

@property(nonatomic, strong) NSMutableArray *contactsArray;

+(NSMutableArray *) emptyContactArray;

-(int) indexForLetter:(unichar)character;
-(Contact *) contactAtIndexPath:(NSIndexPath *)indexPath;
-(NSArray *) letterArray;
-(int) count;
-(NSObject *) objectAtIndex:(int)index;


@end
