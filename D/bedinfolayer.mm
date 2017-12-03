#import "bedinfolayer.h"


@implementation bedinfolayer

@synthesize team0point,team1point;

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
        [self setContentSize:CGSizeMake(0, 0)];
        bed = [[numbers alloc] init];
        [bed setOpacity:0 time:0];
        [bed setPositionInPixels:CGPointMake(43, 0)];
        [self addChild:bed];
        //let's create the four sprites
        hart = [CCSprite spriteWithFile:@"heart.png"];
        [hart setOpacity:0];
        [self addChild:hart];
        diam = [CCSprite spriteWithFile:@"diamond.png"];
        [diam setOpacity:0];
        [self addChild:diam];
        club = [CCSprite spriteWithFile:@"club.png"];
        [club setOpacity:0];
        [self addChild:club];
        spad = [CCSprite spriteWithFile:@"spade.png"];
        [spad setOpacity:0];
        [self addChild:spad];

	}
	return self;
}

//end of important for every class that inherits from CCLayer


- (void) hide {
    [bed setOpacity:0 time:0.1];
    [hart runAction:[CCFadeTo actionWithDuration:0.1 opacity:0]];
    [club runAction:[CCFadeTo actionWithDuration:0.1 opacity:0]];
    [spad runAction:[CCFadeTo actionWithDuration:0.1 opacity:0]];
    [diam runAction:[CCFadeTo actionWithDuration:0.1 opacity:0]];
}

-(void) showWith:(int)bedAmount type:(Card::cardType)bedsuite teamID:(int)team {
    [bed setNum:bedAmount];
    if (team == 0) {
        [self setPositionInPixels:team0point];
        [bed setPositionInPixels:CGPointMake(0,0)];
        [club setPositionInPixels:CGPointMake(30,0)];
        [hart setPositionInPixels:CGPointMake(30,0)];
        [spad setPositionInPixels:CGPointMake(30,0)];
        [diam setPositionInPixels:CGPointMake(30,0)];
        
    } else {
        [self setPositionInPixels:team1point];
        [bed setPositionInPixels:CGPointMake(30,0)];
        [club setPositionInPixels:CGPointMake(0,0)];
        [hart setPositionInPixels:CGPointMake(0,0)];
        [spad setPositionInPixels:CGPointMake(0,0)];
        [diam setPositionInPixels:CGPointMake(0,0)];
    }
    //let's appear the elements, by fading them in
    [bed setOpacity:255 time:0.5];
    if  (bedsuite == Card::Heart) {
        [hart runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];
    } else if  (bedsuite == Card::Club) {
        [club runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];
    } else if  (bedsuite == Card::Spade) {
        [spad runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];
    } else {
        [diam runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];
    }
}

@end
