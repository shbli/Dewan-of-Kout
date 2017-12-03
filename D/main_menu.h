
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "fadeDel.h"
#import "pre_playnow.h"
#import "manu_2.h"
#import "rvwgmmsg.h"
#include "global_keys.h"

@interface main_menu : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    NSMutableArray *leftLine;
    NSMutableArray *rightLine;
    NSMutableArray *cardslist;
    CCMenu* buttons;
    CCSprite* logo;
    CCSprite* about_us_sprite;
    float backGroundHeight;
    CCSprite *background;
    bool swipeAccepted;
    CGPoint startSwipePos;
    CCLayer* main;
#ifdef freeVersion
    bool startFlashingFreeButton;
    bool decreasingFreeButton;
    CCSprite* underFreeButton;
    CCMenuItemImage* FullVersionButton;
#endif
}

@property (nonatomic,retain) CCMenu* buttons;

+(CCScene *) scene;
-(int) nextElement : (int) i;
-(int) prevElement: (int) i;
-(void) play_card_sound;
-(void) left;
//-(void) left_2;
-(void) right;
-(void) updateCardsZlevel;
-(void) updateCardsPos;
-(void) playNowClicked;
-(void) contactUs;
-(void) aboutUs;
-(void) remove_aboutUs;
-(void) tuturial;
-(void) changeLanguage;
-(void) creatCardsMenu;
-(void) changeLanguagestep2;
- (CGPoint) posX: (float) x posY: (float) y;
-  (CCLayer*) getMain;
- (void) createTwitterButton;
- (void) followUsOnTwitter;
- (void) ourSite;
#ifdef freeVersion
-(void) fullVersionClicked;
#endif

@end
