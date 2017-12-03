#import "gameover.h"


@implementation gameover



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
-(id) initWithWin:(BOOL)win
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self setContentSize:CGSizeMake(0, 0)];
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
        //this creates a menu with two buttons, ok and cancel
        NSString* message;
        NSString* ok_file;
        NSString* ok_clicked;
        NSString* cancel;
        NSString* cancel_clicked;

        int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
        if (langID == arabic) {
            if (win) {
                message = @"you_win_ar.png";
            } else {
                message = @"you_lose_ar.png";
            }
            ok_file = @"home.png";
            cancel = @"playagain.png";
            ok_clicked = @"home_clicked.png";
            cancel_clicked = @"playagain_clicked.png";
        } else {
            //anything unnormal, we'll just make it english
            if (win) {
                message = @"you_win_en.png";
            } else {
                message = @"you_lose_en.png";
            }
            ok_file = @"home.png";
            cancel = @"playagain.png";
            ok_clicked = @"home_clicked.png";
            cancel_clicked = @"playagain_clicked.png";
        }
        
        CCSprite* messagesprite = [CCSprite spriteWithFile:message];
        CCMenuItemImage *okbutton = [CCMenuItemImage itemFromNormalImage:ok_file selectedImage:ok_clicked target:self selector:@selector(ok)];
        CCMenuItemImage *cancelbutton = [CCMenuItemImage itemFromNormalImage:cancel selectedImage:cancel_clicked target:self selector:@selector(cancel)];
        [self addChild:messagesprite];
        CCMenu* menu = [CCMenu menuWithItems:okbutton,cancelbutton, nil];
        [self addChild:menu];
        [menu setPositionInPixels:CGPointMake(0, 0)];
        [messagesprite setPositionInPixels:CGPointMake(0, 0)];
        [okbutton setPositionInPixels:CGPointMake(-110, -70)];
        [cancelbutton setPositionInPixels:CGPointMake(110, -70)];
	}
	return self;
}


//end of important for every class that inherits from CCLayer

- (void) ok {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [loading setSelector:mainMenuSelector];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[loading node]]];
}

-(void) cancel {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [loading setSelector:inGameSelector];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[loading node]]];
}


@end
