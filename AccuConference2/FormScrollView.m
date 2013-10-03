#import "FormScrollView.h"

@implementation FormScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height * 2);
    }
    return self;
}

-(void)awakeFromNib{
}

@end
