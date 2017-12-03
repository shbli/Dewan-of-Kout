#import "loading.h"

@implementation loading



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
    [self setPositionInPixels:CGPointMake(winSizeInPixels.width/2, winSizeInPixels.height/2)];
    [self setScale:(winSizeInPixels.width/origwallw)];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadTheNewScene) userInfo:nil repeats:NO];
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



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	loading *layer = [loading node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	
    //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
	// return the scene
	return scene;
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
        [self setPositionInPixels:CGPointMake(winSizeInPixels.width/2, winSizeInPixels.height/2)];
        [self setScale:(winSizeInPixels.width/origwallw)];
        [self setContentSize:CGSizeMake(0, 0)];
        logowall = [CCSprite spriteWithFile:@"Loading01.png"];
        [self addChild:logowall];
        CCSprite* logo = [CCSprite spriteWithFile:@"Loading02.png"];
        [self addChild:logo];
        decreasing = false;
        [self scheduleUpdate];
        
	}
	return self;
}

-(void) update:(ccTime)delta {
    if (decreasing) {
        [logowall setOpacity:([logowall opacity] - (delta * 200))];
        if ([logowall opacity] <= 150) {
            decreasing = false;
        }
    } else {
        [logowall setOpacity:([logowall opacity] + (delta * 200))];
        if ([logowall opacity] >= 250) {
            decreasing = true;
        }
    }
}

-(void) loadTheNewScene {
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    if (selector == inGameSelector) {
        //transait to game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[manu_2 node]]];
    }
    if (selector == mainMenuSelector) {
        //transait to game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[main_menu node]]];        
    }
}

+(void) setSelector:(int) val {
    selector = val;
}
//end of important for every class that inherits from CCLayer


@end
