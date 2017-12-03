
// Import the interfaces
#import "splash_screen.h"
#import "main_menu.h"

// splash_screen implementation
@implementation splash_screen

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	splash_screen *layer = [splash_screen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        //taking screen size, saving it to variable called winSize
        winSize = [[CCDirector sharedDirector] winSizeInPixels];
        backGroundHeight =  winSize.width/origwallw*origwallh;
        
        //set higher sound level
        [SimpleAudioEngine sharedEngine].effectsVolume = 20.0;

        //we'll set the position of the layer that we are in so it's in the middle of the screen
//        [self setPositionInPixels:CGPointMake(winSize.width/2,winSize.height/2)];
        main = [CCLayer node];
        [self addChild:main];
        [self setScale:((winSize.width/origwallw))];
        [self setPositionInPixels:CGPointMake(0, 0)];
        [main setPositionInPixels:CGPointMake(winSize.width/2,winSize.height/2)];
        //we'll start by adding a sprite that represents the background for the menu
        splashScreen = [CCSprite spriteWithFile:@"splash_screen.png"];
        [main addChild:splashScreen];
        [splashScreen setOpacity:0];
        [splashScreen runAction:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.7 opacity:255] rate:4]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"compassgames_startup.wav"];

        //now, we'll add the logo on that screen as another sprite, no need to save that variable
#ifdef freeVersion
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeSplashScreen1Free) userInfo:nil repeats:NO];
#else
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeSplashScreen1) userInfo:nil repeats:NO];
#endif
	}
	return self;
}

-(void) removeSplashScreen1 {
    [splashScreen runAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.25 opacity:0] rate:4],[CCCallFunc actionWithTarget:self selector:@selector(replaceWithGameLogo)] , nil]];
}

-(void) removeSplashScreen1Free {
    [splashScreen runAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.25 opacity:0] rate:4],[CCCallFunc actionWithTarget:self selector:@selector(replaceWithFreeAd)] , nil]];
}

-(void) replaceWithFreeAd {
    [self removeChild:splashScreen cleanup:YES];
    splashScreen = [CCSprite spriteWithFile:@"splash_ad.png"];
    [main addChild:splashScreen];
    [splashScreen setOpacity:0];
    [splashScreen runAction:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.7 opacity:255] rate:4]];
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(removeSplashScreen1) userInfo:nil repeats:NO];
}

-(void) replaceWithGameLogo {
    [self removeChild:splashScreen cleanup:YES];
    //we'll start by adding a sprite that represents the background for the menu
    CCSprite* background = [CCSprite spriteWithFile:@"whitewall.png"];
    [background setOpacity:0];
    [background runAction:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.25 opacity:255] rate:4]];
    [main addChild:background];
    
    //now, we'll add the logo on that screen as another sprite, no need to save that variable
    CCSprite* logo = [CCSprite spriteWithFile:@"menu_logo.png"];
    [logo setOpacity:0];
    [logo runAction:[CCEaseInOut actionWithAction:[CCFadeTo actionWithDuration:0.25 opacity:255] rate:4]];
    [main addChild:logo];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(replaceSceneStep2) userInfo:nil repeats:NO];
    [[SimpleAudioEngine sharedEngine] playEffect:@"welcome_message.wav"];

}

-(void) replaceSceneStep2 {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[main_menu node]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
