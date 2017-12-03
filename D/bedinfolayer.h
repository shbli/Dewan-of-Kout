#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "numbers.h"
#import "card.h"

@interface bedinfolayer : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    CGPoint team0point;
    CGPoint team1point;
    //hold the bed amount label
    numbers* bed;
    //holds images on the
    CCSprite* club;
    CCSprite* diam;
    CCSprite* spad;
    CCSprite* hart;
    
}

@property CGPoint team0point;
@property CGPoint team1point;
 

-(void) hide;
-(void) showWith:(int) bedAmount type:(Card::cardType) bedsuite teamID:(int) team;

@end
