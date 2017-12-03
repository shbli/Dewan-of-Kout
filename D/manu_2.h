#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "global_keys.h"
#import "SimpleAudioEngine.h"
#import "homeconfmsg.h"
#include "dealer.h"
#define onTopOfDealerZvalue 500
static bool tut;

@interface manu_2 : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    float backGroundHeight;
    CCSprite *background;
    CCSprite *sofa_bottom;
    CCSprite *sofa_top;
    CCSprite *sofa_left;
    CCSprite *sofa_right;
    CCSprite *sofa_small_left;
    CCSprite *sofa_small_right;
    dealer *gameDealer;
    float scoreH;
    int pageNum;
    CCMenu* menu;
    CCLayer* main;
}

@property (nonatomic,retain) CCMenu* menu;

+(CCScene *) scene;
+(void) setTut:(BOOL) val;
-(void) showNextPage;
-(void) clickedTest;

@end
