#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include "global_keys.h"
#import "SimpleAudioEngine.h"
#define QString NSString*
#import "fadeDel.h"
@interface rvwgmmsg : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
}

- (void) reviewNow;
- (void) laterTime;
- (void) dontRemindMe;


@end
