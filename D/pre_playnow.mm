#import "pre_playnow.h"


@implementation pre_playnow



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
	}
	return self;
}

- (id) initWithDad: (main_menu*) dad {
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff
        father = dad;
        //first, the wall of that menu
        CCSprite* wall = [CCSprite spriteWithFile:@"play_now_wall.png"];
        [self addChild:wall];
        //strings for diffrent file names
        NSString* diffcultyfile;
        NSString* gameSpeedFile;
        NSString* gaidFileName;
        NSString* themeFile;
        NSString* easyFile;
        NSString* mediumFile;
        NSString* hardFile;
        NSString* slowFile;
        NSString* fastFile;
        NSString* fiftyFile;
        NSString* hundredFile;
        NSString* twentyFiveFile;
        NSString* okFile;
        NSString* cancelFile;
        
        int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
        if (langID == arabic) {
            diffcultyfile = @"diff_ar.png";
            gameSpeedFile = @"game_speed_ar.png";
            gaidFileName = @"gaid_ar.png";
            themeFile = @"theme_ar.png";
            easyFile = @"easy_ar.png";
            mediumFile = @"mid_ar.png";
            hardFile = @"hard_ar.png";
            slowFile = @"slow_ar.png";
            fastFile = @"fast_ar.png";
            fiftyFile = @"51_ar.png";
            hundredFile = @"101_ar.png";
            twentyFiveFile = @"26_ar.png";
            cancelFile = @"main_cancel_en.png";
            okFile = @"main_ok_en.png";
        } else {
            diffcultyfile = @"diff_en.png";
            gameSpeedFile = @"game_speed_en.png";
            gaidFileName = @"gaid_en.png";
            themeFile = @"theme_en.png";
            easyFile = @"easy_en.png";
            mediumFile = @"mid_en.png";
            hardFile = @"hard_en.png";
            slowFile = @"slow_en.png";
            fastFile = @"fast_en.png";
            fiftyFile = @"51_en.png";
            hundredFile = @"101_en.png";
            twentyFiveFile = @"26_en.png";
            cancelFile = @"main_cancel_en.png";
            okFile = @"main_ok_en.png";
        }
        
        //these to construct things to look like table
        float x = - ([wall contentSizeInPixels].width /2) + (150);
        float y = ( [wall contentSizeInPixels].height /2) - (110);
        float ydiff = - 85;
        const float xdiff = 160;
#ifdef freeVersion
        ydiff = -125;
#endif
        int counter = 0;
        //first thing adding the diffculty word
        CCSprite* diffculty = [CCSprite spriteWithFile:diffcultyfile];
        [diffculty setPositionInPixels:CGPointMake(x, y)];
        [self addChild:diffculty];
        counter++;
        //now the second in the same y
        CCSprite* gameSpeed = [CCSprite spriteWithFile:gameSpeedFile];
        [gameSpeed setPositionInPixels:CGPointMake(x,y + (ydiff*counter))];
        [self addChild:gameSpeed];
#ifndef freeVersion
        counter++;
        //third is gaid
        CCSprite* gaid = [CCSprite spriteWithFile:gaidFileName];
        [gaid setPositionInPixels:CGPointMake(x,y + (ydiff*counter))];
        [self addChild:gaid];
#endif
        counter++;
        //fourth is theme
        CCSprite* thm = [CCSprite spriteWithFile:themeFile];
        [thm setPositionInPixels:CGPointMake(x,y + (ydiff*counter))];
        [self addChild:thm];

        //now adding menu items
        //difficulty words
        counter = 0;
        int diffID = [[NSUserDefaults standardUserDefaults] integerForKey:diffculty_key];
        easy = [CCMenuItemImage itemFromNormalImage:easyFile selectedImage:easyFile target:self selector:@selector(easy_clicked)];
        [easy setPositionInPixels:CGPointMake(x + (xdiff*1), y + (ydiff*counter))];
        if (diffID != easyID) {
            [easy setOpacity:halfOpacity];
        }
        medium = [CCMenuItemImage itemFromNormalImage:mediumFile selectedImage:mediumFile target:self selector:@selector(medium_clicked)];
        [medium setPositionInPixels:CGPointMake(x + (xdiff*2), y + (ydiff*counter))];
        if (diffID != mediumID) {
            [medium setOpacity:halfOpacity];
        }
        hard = [CCMenuItemImage itemFromNormalImage:hardFile selectedImage:hardFile target:self selector:@selector(hard_clicked)];
        [hard setPositionInPixels:CGPointMake(x + (xdiff*3), y + (ydiff*counter))];
        if (diffID != hardID) {
            [hard setOpacity:halfOpacity];
        }
        //gamespeed files
        counter++;
        int speedVal = [[NSUserDefaults standardUserDefaults] integerForKey:gamespeed_key];
        slow = [CCMenuItemImage itemFromNormalImage:slowFile selectedImage:slowFile target:self selector:@selector(slow_speed_clicked)];
        [slow setPositionInPixels:CGPointMake(x + (xdiff*1), y + (ydiff*counter))];
        if (speedVal != 3) {
            [slow setOpacity:halfOpacity];
        }
        midSpeed = [CCMenuItemImage itemFromNormalImage:mediumFile selectedImage:mediumFile target:self selector:@selector(medium_speed_clicked)];
        [midSpeed setPositionInPixels:CGPointMake(x + (xdiff*2), y + (ydiff*counter))];
        if (speedVal != 2) {
            [midSpeed setOpacity:halfOpacity];
        }
        fast = [CCMenuItemImage itemFromNormalImage:fastFile selectedImage:fastFile target:self selector:@selector(fast_speed_clicked)];
        [fast setPositionInPixels:CGPointMake(x + (xdiff*3), y + (ydiff*counter))];
        if (speedVal != 1) {
            [fast setOpacity:halfOpacity];
        }
        
        //gaid files
#ifdef freeVersion
        [[NSUserDefaults standardUserDefaults] setInteger:26 forKey:gaidtotal_key];
#endif
#ifndef freeVersion
        counter++;
        int gaidVal = [[NSUserDefaults standardUserDefaults] integerForKey:gaidtotal_key];
        twentyFive = [CCMenuItemImage itemFromNormalImage:twentyFiveFile selectedImage:twentyFiveFile target:self selector:@selector(twentyFive_clicked)];
        [twentyFive setPositionInPixels:CGPointMake(x + (xdiff*1), y + (ydiff*counter))];
        if (gaidVal != 26) {
            [twentyFive setOpacity:halfOpacity];
        }
        fifty = [CCMenuItemImage itemFromNormalImage:fiftyFile selectedImage:fiftyFile target:self selector:@selector(fifty_clicked)];
        [fifty setPositionInPixels:CGPointMake(x + (xdiff*2), y + (ydiff*counter))];
        if (gaidVal != 51) {
            [fifty setOpacity:halfOpacity];
        }
        hundered = [CCMenuItemImage itemFromNormalImage:hundredFile selectedImage:hundredFile target:self selector:@selector(hundred_clicked)];
        [hundered setPositionInPixels:CGPointMake(x + (xdiff*3), y + (ydiff*counter))];
        if (gaidVal != 101) {
            [hundered setOpacity:halfOpacity];
        }
#endif
        //theme files
        counter++;
        int themeVal = [[NSUserDefaults standardUserDefaults] integerForKey:theme_key];
        blue = [CCMenuItemImage itemFromNormalImage:@"blu_thumb.png" selectedImage:@"blu_thumb.png" target:self selector:@selector(blue_clicked)];
        [blue setPositionInPixels:CGPointMake(x + (xdiff*1), y + (ydiff*counter))];
        if (themeVal != blueID) {
            [blue setOpacity:halfOpacity];
        }
        silver = [CCMenuItemImage itemFromNormalImage:@"silver_thumb.png" selectedImage:@"silver_thumb.png" target:self selector:@selector(silver_clicked)];
        [silver setPositionInPixels:CGPointMake(x + (xdiff*2), y + (ydiff*counter))];
        if (themeVal != silverID) {
            [silver setOpacity:halfOpacity];
        }
        red = [CCMenuItemImage itemFromNormalImage:@"red_thumb.png" selectedImage:@"red_thumb.png" target:self selector:@selector(red_clicked)];
        [red setPositionInPixels:CGPointMake(x + (xdiff*3), y + (ydiff*counter))];
        if (themeVal != redID) {
            [red setOpacity:halfOpacity];
        }
        
        //adding ok and cencel buttons
        okButton = [CCMenuItemImage itemFromNormalImage:okFile selectedImage:okFile target:self selector:@selector(ok_clicked)];
        [okButton setPositionInPixels:CGPointMake(258,-215)];

        cancelButton = [CCMenuItemImage itemFromNormalImage:cancelFile selectedImage:cancelFile target:self selector:@selector(cacel_clicked)];
        [cancelButton setPositionInPixels:CGPointMake(-258, - 215)];
        
        //adding the menu as a child
#ifdef freeVersion
        CCMenu* menu = [CCMenu menuWithItems:silver,easy,medium,hard,slow,midSpeed,fast,blue,red,okButton,cancelButton, nil];
#endif
#ifndef freeVersion
        CCMenu* menu = [CCMenu menuWithItems:silver,twentyFive,easy,medium,hard,slow,midSpeed,fast,fifty,hundered,blue,red,okButton,cancelButton, nil];
#endif
        [menu setPositionInPixels:CGPointMake(0, 0)];
        [self addChild:menu];
	}
	return self;

}
- (void) ok_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[loading node]]];
}
- (void) cacel_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[fadeDel alloc] initWithToDel:self parent:[father getMain] action:[CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.5 position:CGPointMake(-1024, 0)] rate:4]];
    [father buttons].isTouchEnabled = true;
    [father updateCardsPos];
    
}
- (void) blue_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:blueID forKey:theme_key];
    [red stopAllActions];
    [blue stopAllActions];
    [silver stopAllActions];
    [silver runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [red runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [blue runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    
}
- (void) red_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:redID forKey:theme_key];
    [red stopAllActions];
    [blue stopAllActions];
    [silver stopAllActions];
    [silver runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [red runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [blue runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    
}
- (void) silver_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:silverID forKey:theme_key];
    [red stopAllActions];
    [blue stopAllActions];
    [silver stopAllActions];
    [silver runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [red runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [blue runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    
}
- (void) hard_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:hardID forKey:diffculty_key];
    [hard stopAllActions];
    [medium stopAllActions];
    [easy stopAllActions];
    [hard runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [medium runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [easy runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    
}
- (void) medium_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:mediumID forKey:diffculty_key];
    [hard stopAllActions];
    [medium stopAllActions];
    [easy stopAllActions];
    [hard runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [medium runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [easy runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];

    
}
- (void) easy_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:easyID forKey:diffculty_key];
    [hard stopAllActions];
    [medium stopAllActions];
    [easy stopAllActions];
    [hard runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [medium runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [easy runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    
}
- (void) medium_speed_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:gamespeed_key];
    [midSpeed stopAllActions];
    [fast stopAllActions];
    [slow stopAllActions];
    [midSpeed runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [fast runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [slow runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];

    
}
- (void) slow_speed_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:gamespeed_key];
    [midSpeed stopAllActions];
    [fast stopAllActions];
    [slow stopAllActions];
    [midSpeed runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [fast runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [slow runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    
}
- (void) fast_speed_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:gamespeed_key];
    [midSpeed stopAllActions];
    [fast stopAllActions];
    [slow stopAllActions];
    [midSpeed runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [fast runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [slow runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    
}
- (void) hundred_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:101 forKey:gaidtotal_key];
    [hundered stopAllActions];
    [twentyFive stopAllActions];
    [fifty stopAllActions];
    [hundered runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [twentyFive runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [fifty runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    
}
- (void) fifty_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:51 forKey:gaidtotal_key];
    [hundered stopAllActions];
    [twentyFive stopAllActions];
    [fifty stopAllActions];
    [hundered runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [twentyFive runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [fifty runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    
}
- (void) twentyFive_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:26 forKey:gaidtotal_key];
    [hundered stopAllActions];
    [twentyFive stopAllActions];
    [fifty stopAllActions];
    [hundered runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
    [twentyFive runAction:[CCFadeTo actionWithDuration:fadTime opacity:fullOpacity]];
    [fifty runAction:[CCFadeTo actionWithDuration:fadTime opacity:halfOpacity]];
}


//end of important for every class that inherits from CCLayer


@end
