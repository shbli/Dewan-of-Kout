#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "global_keys.h"
#import "manu_2.h"
#import "main_menu.h"

#define inGameSelector 1
#define mainMenuSelector 2

static int selector;

@interface loading : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    CCSprite* logowall;
    bool decreasing;    
}

+(CCScene *) scene;
+(void) setSelector:(int) val;
-(void) loadTheNewScene;
@end
