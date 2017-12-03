// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "global_keys.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer
@interface splash_screen : CCLayer
{
    CGSize winSize;
    float backGroundHeight;
    CCSprite* splashScreen;
    CCLayer *main;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) replaceSceneStep2;
-(void) removeSplashScreen1;
-(void) replaceWithGameLogo;
-(void) removeSplashScreen1Free;
-(void) replaceWithFreeAd;

@end
