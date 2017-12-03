#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include "card.h"

@interface card_layer : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    Card *cardInst;
    CCSprite *back;
    CCSprite *front;
    CCSprite *white;
    CCSprite *black;
    bool faceDown;
}

@property Card* cardInst;

- (id) initWithFile:(NSString*) cardfile type:(Card::cardType) type number:(int) cardNumber;
- (BOOL) cardWithPlayer;
- (BOOL) cardWithDealer;
-(void) giveCardToPlayer: (int) ID;
-(int) player_id_holding_card;
- (void) returnCardToDealer;
- (void) turnFaceDown : (float) time;
- (void) turnFaceUp : (float) time;
- (void) dim : (float) time;
- (void) undim : (float) time;
- (void) flash : (float) time WithTarget: (id) t selector:(SEL) s;
- (float) cardWidth;
- (float) cardHeight;
- (BOOL) contains:(CGPoint) testPoint;
-(void) setZ:(int) zValue;
-(void) faceUpDone;
-(void) faceDownDone;
-(void) setBlackNotVisiable;
-(void) setWhiteNotVisiable;

@end
