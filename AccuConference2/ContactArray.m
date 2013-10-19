#import "ContactArray.h"

@implementation ContactArray

+(NSMutableArray *) emptyContactArray{
    NSMutableArray *retContacts = [[NSMutableArray alloc] initWithCapacity:27];
    for (int i = 0; i < 27; i++) {
        NSMutableArray *letterContacts = [[NSMutableArray alloc] init];
        [retContacts addObject:letterContacts];
    }
    return retContacts;
}


//returns -1 if no contacts have a name that begins with that letter
-(int) indexForLetter:(unichar)character{
    for (NSArray *letterArray in self.contactsArray) {
        unichar lNameChar = [[(Contact *)[letterArray firstObject] lName] characterAtIndex:0];
        if (lNameChar ==  character) {
            return [self.contactsArray indexOfObject:letterArray];
        }
    }
    return -1;
}

-(Contact *) contactAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *letterArray = (NSArray *)[self.contactsArray objectAtIndex:indexPath.section];
    return (Contact *)[letterArray objectAtIndex:indexPath.row];
}

-(NSArray *) letterArray{
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    for (NSArray *letterArray in self.contactsArray) {
        Contact *contact = (Contact *)[letterArray firstObject];
        [letters addObject:[NSString stringWithFormat:@"%c",[contact.lName characterAtIndex:0]]];
    }
    return letters;
}

-(int)count{
    return self.contactsArray.count;
}

-(NSObject *)objectAtIndex:(int)index{
    return [self.contactsArray objectAtIndex:index];
}


@end
