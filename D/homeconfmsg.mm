#import "homeconfmsg.h"

#import "callmenu.h"

@implementation homeconfmsg



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



//end of important for every class that inherits from CCLayer

-(id) initWithFather:(manu_2*) father {
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
        //once this one is coming, we should pause the game, ask the dealer
        [Player::gameDealer pauseGame];
        fath = father;
        //this creates a menu with two buttons, ok and cancel
        NSString* message;
        NSString* ok;
        NSString* ok_clicked;
        NSString* cancel;
        NSString* cancel_clicked;
        
        int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
        if (langID == arabic) {
            message = @"home_message_ar.png";
            ok = @"ok_en.png";
            cancel = @"cancel_en.png";
            ok_clicked = @"ok_en.png";
            cancel_clicked = @"cancel_en.png";
        } else {
            //anything unnormal, we'll just make it english
            message = @"home_message_en.png";
            ok = @"ok_en.png";
            cancel = @"cancel_en.png";
            ok_clicked = @"ok_en.png";
            cancel_clicked = @"cancel_en.png";
        }
        
        CCSprite* messagesprite = [CCSprite spriteWithFile:message];
        CCMenuItemImage *okbutton = [CCMenuItemImage itemFromNormalImage:ok selectedImage:ok_clicked target:self selector:@selector(ok)];
        CCMenuItemImage *cancelbutton = [CCMenuItemImage itemFromNormalImage:cancel selectedImage:cancel_clicked target:self selector:@selector(cancel)];
        [self addChild:messagesprite];
        CCMenu *menu = [CCMenu menuWithItems:okbutton,cancelbutton, nil];
        [self addChild:menu];
        [menu setPositionInPixels:CGPointMake(0, 0)];
        [messagesprite setPositionInPixels:CGPointMake(0,0)];
        [okbutton setPositionInPixels:CGPointMake(-111,-73)];
        [cancelbutton setPositionInPixels:CGPointMake(111,-73)];
        if ([Player::gameDealer menu] != 0) {
            Player::gameDealer.menu.wholeMenu.isTouchEnabled = true;
        }
        
    }
	return self;    
}

-(void) ok {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [loading setSelector:mainMenuSelector];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[loading node]]];
    
}

-(void) cancel {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[fadeDel alloc] initWithToDel:self parent:parent_ action:[CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(-1000, 0)] rate:4]];
    [fath menu].isTouchEnabled = true;
    if ([Player::gameDealer menu] != 0) {
        [[Player::gameDealer menu] wholeMenu].isTouchEnabled = true;
    }
    //ask the dealer to cont the game
    [Player::gameDealer contGame];
}

@end
