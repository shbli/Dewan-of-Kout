#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "global_keys.h"
#import "SimpleAudioEngine.h"
#import "loading.h"

@interface gameover : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
}

-(id) initWithWin:(BOOL) win;
-(void) ok;
-(void) cancel;

@end
