//
//  template_cclayer_class.m
//  Arabs Island Cocos2D
//
//  Created by q8phantom on 6/18/11.
//  Copyright 2011 q8spirit. All rights reserved.
//


//replace every template_cclayer_class with class name

#import "hintbutton.h"
#import "player.h"
#import "dealer.h"

@implementation hintbutton



//important for every class that inherits from CCLayer

-(void) onEnter {
    // called right after a node's init methode is called.
    // If using CCTransitionScene: called when the transition begins.
    
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);

    [super onEnter];
}

-(void) onEnterTransitionDidFinish {
    // Called right after onEnter
    // If using a CCTransitionScence: called when the transition ended.
    
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    [super onEnterTransitionDidFinish];
}

-(void) onExit {
    // called right before node's dealloc methode is called
    // If using a CCTransitionScence: called when the transition has ended
    
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    [super onExit];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    
	// don't forget to call "super dealloc"
	
    [super dealloc];
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff
        //first create normal image
        CCMenu* menu;
        CCMenuItemImage* hintBut = [CCMenuItemImage itemFromNormalImage:@"hint.png" selectedImage:@"hint.png" target:self selector:@selector(hintButtonClicked)];
        menu = [CCMenu menuWithItems:hintBut, nil];
        [self addChild:menu];
        [menu setPositionInPixels:CGPointMake(0, 0)];
        [self setContentSize:CGSizeMake(0, 0)];
        
        light = [CCSprite spriteWithFile:@"hint_light.png"];
        [self addChild:light];
        [light setOpacity:0];
        contFlashing = false;
	}
	return self;
}

-(void) hintButtonClicked {
    if (contFlashing) {
        [Player::gameDealer hintButtonClicked];
    }
}

-(void) flash:(float) time {
    flashingSpeed = time;
    contFlashing = true;
    [self actualFlashing];
}

-(void) actualFlashing {
    if (contFlashing) {
        [light runAction:[CCSequence actions:[CCFadeTo actionWithDuration:flashingSpeed/2.0 opacity:255],[CCFadeTo actionWithDuration:flashingSpeed/2.0 opacity:255*0.5],[CCCallFunc actionWithTarget:self selector:@selector(actualFlashing)], nil]];
    }
}

-(void) stopFlashing {
    contFlashing = false;
    [light stopAllActions];
    [light stopAllActions];
    [light setOpacity:0];
}



//end of important for every class that inherits from CCLayer


@end
