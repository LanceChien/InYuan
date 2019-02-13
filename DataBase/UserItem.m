#import "UserItem.h"

@implementation UserItem
@synthesize userName,song;

- (instancetype)init {
    if (self = [super init]) {
        self.song=[SongItem new];
    }
    return self;
}

@end

