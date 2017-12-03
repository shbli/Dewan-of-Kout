#import "main_menu.h"
#include "main_menu.h"
//#include "loading.h"
//#include "pre_playnow.h"
//#include "rvwgmmsg.h"

#define topCardZLevel 20
#define startxd 190
#define fixedy -80

@implementation main_menu

@synthesize buttons;

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
    [self setScale:((winSizeInPixels.width/origwallw))];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(creatCardsMenu) userInfo:nil repeats:NO];
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
    
    [leftLine release];
    [rightLine release];
    [cardslist release];
	// don't forget to call "super dealloc"
	
    [super dealloc];
}



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	main_menu *layer = [main_menu node];
	
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
        leftLine = [[NSMutableArray alloc] init];
        rightLine = [[NSMutableArray alloc] init];
        cardslist = [[NSMutableArray alloc] init];

        //taking screen size, saving it to variable called winSize
        backGroundHeight = winSizeInPixels.width/origwallw*origwallh;
        
        main = [CCLayer node];
        [self addChild:main];
        //we'll scale it, so when adding elements they'll all scale to that size
        [self setScale:((winSizeInPixels.width/origwallw))];
        //we'll set the position of the layer that we are in so it's in the middle of the screen
        [main setPositionInPixels:CGPointMake(winSizeInPixels.width/2,winSizeInPixels.height/2)];
        
        
        //we'll start by adding a sprite that represents the background for the menu
        background = [CCSprite spriteWithFile:@"menu_wall.png"];
        [main addChild:background];
#ifdef freeVersion
        int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
        
        if (langID == arabic) {
            FullVersionButton = [CCMenuItemImage itemFromNormalImage:@"fullAr.png" selectedImage:@"fullAr.png" target:self selector:@selector(fullVersionClicked)];
        } else {
            FullVersionButton = [CCMenuItemImage itemFromNormalImage:@"fullEn.png" selectedImage:@"fullEn.png" target:self selector:@selector(fullVersionClicked)];            
        }
        [FullVersionButton setPositionInPixels:CGPointMake(-155, 40)];
        CCMenu* fullversionmenu = [CCMenu menuWithItems:FullVersionButton, nil];
        [fullversionmenu setPositionInPixels:CGPointMake(0, 0)];
        [fullversionmenu setContentSizeInPixels:CGSizeMake(0, 0)];
        [main addChild:fullversionmenu z:1];
        underFreeButton = [CCSprite spriteWithFile:@"white_flash.png"];
        [underFreeButton setPositionInPixels:CGPointMake(-155, 40)];
        [main addChild:underFreeButton];
        startFlashingFreeButton = true;
#endif
#ifndef freeVersion
        //now, we'll add the logo on that screen as another sprite, no need to save that variable
        logo = [CCSprite spriteWithFile:@"menu_logo.png"];
        [logo setPositionInPixels:CGPointMake(-155,40)];
        [main addChild:logo];
#endif
        
        //now we'll add some sprites on the left and right and start moving them, some action on the menu so user knows it's not lagging
        int shapex;
        CCSprite* shape = [CCSprite spriteWithFile:@"shapes.png"];
        shapex = [shape contentSizeInPixels].width - (origwallw/2);
        [shape setPositionInPixels:CGPointMake(shapex,-origwallh/2)];
        [main addChild:shape];
        [leftLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        CCSprite *last = [leftLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [leftLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [leftLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [leftLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [leftLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [leftLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [leftLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [leftLine addObject:shape];
        
        //it's time for the ones on the right
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        shapex = [shape contentSizeInPixels].width - (origwallw/2);
        [shape setPositionInPixels:CGPointMake((origwallw/2) - [shape contentSizeInPixels].width,-origwallh/2)];
        shapex = [shape positionInPixels].x;
        [main addChild:shape];
        [rightLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [rightLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [rightLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [rightLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [rightLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [rightLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [rightLine addObject:shape];
        shape = [CCSprite spriteWithFile:@"shapes.png"];
        last = [rightLine lastObject];
        [shape setPositionInPixels:CGPointMake(shapex, [last positionInPixels].y + [shape contentSizeInPixels].height + 10)];
        [main addChild:shape];
        [rightLine addObject:shape];
        
        
        //check for some values
        int counter =     [[NSUserDefaults standardUserDefaults] integerForKey:@"reviewcount"];
        if(counter != -1) {
            if (counter < 5) {
                counter++;
                [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"reviewcount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                //display a review message
                [main addChild:[[rvwgmmsg alloc] init]];
            }
        }
        CCLOG(@"left line size %d", [leftLine count]);
        buttons = 0;
        [self setIsTouchEnabled:true];
        [self scheduleUpdate];
        
        //done the work for the moving left anf right lines, now we'll add the menu cards after the transition
        
        [self createTwitterButton];
	}
	return self;
}


//end of important for every class that inherits from CCLayer
#ifdef freeVersion
-(void) fullVersionClicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/dewan-of-kout/id491157833?mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}
#endif

-(void) update:(ccTime)delta{
    
    //here, in our update methode, we'll move the leftline shapes
    CCSprite *shape;
    CCSprite *prev;
    for (int i = 0; i < [leftLine count]; i++) {
        shape = [leftLine objectAtIndex:i];
        [shape setPositionInPixels: CGPointMake([shape positionInPixels].x, [shape positionInPixels].y - ( delta*20))];
        if ([shape positionInPixels].y+ ( [shape contentSizeInPixels].height /2) < - (origwallh/2)) {
            //we'll move it up, it's not visiable
            prev = [leftLine objectAtIndex:[self prevElement:i]];
            [shape setPositionInPixels: CGPointMake([shape positionInPixels].x,[prev positionInPixels].y + [shape contentSizeInPixels].height +10)];
        }
    }
    for (int i = 0; i < [rightLine count]; i++) {
        shape = [rightLine objectAtIndex:i];
        [shape setPositionInPixels: CGPointMake([shape positionInPixels].x, [shape positionInPixels].y + ( delta*20))];
        if ([shape positionInPixels].y - ( [shape contentSizeInPixels].height /2) > (origwallh/2) ) {
            //we'll move it up, it's not visiable
            prev = [rightLine objectAtIndex:[self nextElement:i]];
            [shape setPositionInPixels: CGPointMake([shape positionInPixels].x,[prev positionInPixels].y - ( [shape contentSizeInPixels].height +10))];
        }
    }
#ifdef freeVersion
    if (startFlashingFreeButton) {
        if (decreasingFreeButton) {
            [underFreeButton setOpacity:[underFreeButton opacity] - (250 * delta)] ;
            if ([underFreeButton opacity] < 70) {
                decreasingFreeButton = false;
            }
        } else {
            [underFreeButton setOpacity:[underFreeButton opacity] + (250 * delta)] ;
            if (underFreeButton.opacity > 250) {
                decreasingFreeButton = true;
            }
        }
    }
#endif

    
}

////this returns next element in rightLine providing i element

- (int) nextElement:(int)i {
    if (i == [rightLine count] - 1) {
        //this is the last element, next one is 0
        return 0;
    }
    return i+1;
}


//this returns prev element in leftLine providing i element
- (int) prevElement:(int)i {
    if (i == 0) {
        //this is the last element, next one is 0
        return [leftLine count] - 1;
    }
    return i-1;
}

- (void) changeLanguage {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [buttons setIsTouchEnabled:false];
    int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
    if (langID == arabic ) {
        [[NSUserDefaults standardUserDefaults] setInteger:english forKey:langkey];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:arabic forKey:langkey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [buttons runAction:[CCSequence actions:[CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:0.2 position:[self posX:500 posY:0]] rate:4],[CCCallFunc actionWithTarget:self selector:@selector(changeLanguagestep2)], nil]];
}

- (void) changeLanguagestep2 {
    //deleting the old menu from memory
    [main removeChild:buttons cleanup:YES];
    
    //creating a new menu, providing we changed the language variable before
    [self creatCardsMenu];

}

- (void) tuturial {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [manu_2 setTut:true];
    [loading setSelector:inGameSelector];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[loading node]]];
}

- (void) aboutUs {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [buttons setIsTouchEnabled:false];
    //auto deletes itself, and the object after running an action on it
    [[fadeDel alloc] initWithToDel:buttons parent:main action:[CCMoveBy actionWithDuration:0.2 position:[self posX:500 posY:0]]];
    buttons = 0;
#ifdef freeVersion
    [FullVersionButton runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:0.5] rate:4]];
    [FullVersionButton runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:0 posY:210]] rate:4]];
    [underFreeButton runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:0.5] rate:4]];
    [underFreeButton runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:0 posY:210]] rate:4]];
#endif
#ifndef freeVersion
    //now we need to make the logo smaller
    [logo runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:0.35] rate:4]];
    [logo runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:0 posY:210]] rate:4]];
#endif
    about_us_sprite = [CCSprite spriteWithFile:@"about_us.png"];
    [about_us_sprite setPositionInPixels:CGPointMake(0, -1024)];
    [about_us_sprite runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:0 posY:-45]] rate:4]];
    [main addChild:about_us_sprite];

}

- (void) playNowClicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [manu_2 setTut:false];
    [loading setSelector:inGameSelector];
    pre_playnow *preplayMenu = [[pre_playnow alloc] initWithDad:self];
    [main addChild:preplayMenu];
    [main reorderChild:preplayMenu z:topCardZLevel+30];
    buttons.isTouchEnabled = false;
    [preplayMenu setPositionInPixels:CGPointMake(winSizeInPixels.width*1.5, 0)];
    [preplayMenu runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 0)] rate:4]];

}

- (void) contactUs {
    CCLOG(@"Contact us");
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    NSString *urlString = [NSString stringWithFormat:@"mailto:support@compassgames.net?subject=Dewan of Kout Support&body=Please type your Question here English or Arabic!"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}


- (void) remove_aboutUs {
    [self creatCardsMenu];
    //auto deletes itself, and the object after running an action on it
    [[fadeDel alloc] initWithToDel:about_us_sprite parent:main action:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:[self posX:0 posY:-1024]] rate:4]];
#ifdef freeVersion
    [FullVersionButton runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0] rate:4]];
    [FullVersionButton runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:-155 posY:60]] rate:4]];
    [underFreeButton runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0] rate:4]];
    [underFreeButton runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:-155 posY:60]] rate:4]];
#endif
#ifndef freeVersion
    //now we need to make the logo smaller
    [logo runAction:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0] rate:4]];
    [logo runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5f position:[self posX:-155 posY:60]] rate:4]];
#endif    
}

- (void) left {
    [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_1.wav"];
    buttons.isTouchEnabled = false;
    CCMenuItemImage *first = [cardslist objectAtIndex:0];
    [cardslist removeObjectAtIndex:0];
    CCSequence *sequence = [CCSequence actions:[CCMoveBy actionWithDuration:0.1 position:[self posX:200 posY:0]],[CCCallFunc actionWithTarget:self selector:@selector(updateCardsZlevel)],[CCMoveBy actionWithDuration:0.1 position:[self posX:-200 posY:0]], [CCCallFunc actionWithTarget:self selector:@selector(updateCardsPos)],nil];
    [first runAction:sequence];
    [cardslist addObject:first];
}

- (void) right {
    [[SimpleAudioEngine sharedEngine] playEffect:@"play_card_1.wav"];
    buttons.isTouchEnabled = false;
    CCMenuItemImage *last = [cardslist objectAtIndex:[cardslist count] - 1];
    [cardslist removeObjectAtIndex: [cardslist count] - 1];
    CCSequence *sequence = [CCSequence actions:[CCMoveBy actionWithDuration:0.1 position:[self posX:200 posY:0]],[CCCallFunc actionWithTarget:self selector:@selector(updateCardsZlevel)],[CCMoveBy actionWithDuration:0.1 position:[self posX:-200 posY:0]], [CCCallFunc actionWithTarget:self selector:@selector(updateCardsPos)],nil];
    [last runAction:sequence];
    [cardslist insertObject:last atIndex:0];
}

- (void) updateCardsZlevel {
    CCMenuItemImage* item;
    for (int i = 0; i < [cardslist count]; i++) {
        item = [cardslist objectAtIndex:i];
        [buttons reorderChild:item z:topCardZLevel + i];
    }
}

- (void) updateCardsPos {
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    [buttons setPositionInPixels:CGPointMake(0, 0)];
    int startx = startxd;
    CCMenuItemImage* item;
    for (int i = 0; i < [cardslist count]; i++) {
        item = [cardslist objectAtIndex:i];
        [item setPositionInPixels:CGPointMake(startx,fixedy)];
        startx -= 5;
    }
    buttons.isTouchEnabled = true;
    
    for (int i = 0; i < [cardslist count]; i++) {
        item = [cardslist objectAtIndex:i];
        item.isEnabled = false;
    }

    item = [cardslist objectAtIndex:[cardslist count] - 1];
    item.isEnabled = true;
    
    
}


- (void) creatCardsMenu {


    NSString* contactusfile;
    NSString* aboutfile;
    NSString* languagefile;
    NSString* tuturialfile;
    NSString* playnowfile;
    int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
    
    if (langID == arabic) {
        contactusfile =  @"a5.png";
        aboutfile =  @"a4.png";
        languagefile = @"a3.png";
        tuturialfile = @"a2.png";
        playnowfile = @"a1.png";
    } else {
        //anything unnormal, we'll just make it english
        contactusfile =  @"e5.png";
        aboutfile =  @"e4.png";
        languagefile =  @"e3.png";
        tuturialfile =  @"e2.png";
        playnowfile = @"e1.png";
    }
    [cardslist removeAllObjects];
    int startx = startxd;
    float actionTime = 0.1f;
    CCMenuItemImage* contactcard = [CCMenuItemImage itemFromNormalImage:contactusfile selectedImage:contactusfile target:self selector:@selector(contactUs)];
    CCMenuItemImage* aboutcard = [CCMenuItemImage itemFromNormalImage:aboutfile selectedImage:aboutfile target:self selector:@selector(aboutUs)];
    CCMenuItemImage* langcard = [CCMenuItemImage itemFromNormalImage:languagefile selectedImage:languagefile target:self selector:@selector(changeLanguage)];
    CCMenuItemImage* tutcard = [CCMenuItemImage itemFromNormalImage:tuturialfile selectedImage:tuturialfile target:self selector:@selector(tuturial)];
    CCMenuItemImage* playcard = [CCMenuItemImage itemFromNormalImage:playnowfile selectedImage:playnowfile target:self selector:@selector(playNowClicked)];
    CCMenuItemImage* left = [CCMenuItemImage itemFromNormalImage:@"press_l.png" selectedImage:@"press_lp.png" target:self selector:@selector(left)];
    CCMenuItemImage* right = [CCMenuItemImage itemFromNormalImage:@"press_r.png" selectedImage:@"press_rp.png" target:self selector:@selector(right)];
    buttons = [CCMenu menuWithItems:contactcard,aboutcard,langcard,tutcard,playcard,left,right, nil];
    [main addChild:buttons];
    [cardslist addObject:contactcard];
    [cardslist addObject:aboutcard];
    [cardslist addObject:langcard];
    [cardslist addObject:tutcard];
    [cardslist addObject:playcard];
    [self updateCardsPos];
    
    [buttons setPositionInPixels:CGPointMake(0, 0)];

    [contactcard setPositionInPixels:CGPointMake(startx+300,fixedy)];
    startx -= 5;
    [contactcard runAction:[CCMoveTo actionWithDuration:actionTime position: [self posX:startx posY:fixedy]]];
    [NSTimer scheduledTimerWithTimeInterval:(actionTime/2.0) target:self selector:@selector(play_card_sound) userInfo:nil repeats:NO];
    actionTime += 0.07;
    
    [aboutcard setPositionInPixels:CGPointMake(startx + 300,fixedy)];
    startx -= 5;
    [aboutcard runAction:[CCMoveTo actionWithDuration:actionTime position: [self posX:startx posY:fixedy]]];
    [NSTimer scheduledTimerWithTimeInterval:(actionTime/2.0) target:self selector:@selector(play_card_sound) userInfo:nil repeats:NO];
    actionTime += 0.07;

    [langcard setPositionInPixels:CGPointMake(startx + 300,fixedy)];
    startx -= 5;
    [langcard runAction:[CCMoveTo actionWithDuration:actionTime position:[self posX:startx posY:fixedy]]];
    [NSTimer scheduledTimerWithTimeInterval:(actionTime/2.0) target:self selector:@selector(play_card_sound) userInfo:nil repeats:NO];
    actionTime += 0.07;

    [tutcard setPositionInPixels:CGPointMake(startx + 300,fixedy)];
    startx -= 5;
    [tutcard runAction:[CCMoveTo actionWithDuration:actionTime position:[self posX:startx posY:fixedy]]];
    [NSTimer scheduledTimerWithTimeInterval:(actionTime/2.0) target:self selector:@selector(play_card_sound) userInfo:nil repeats:NO];
    actionTime += 0.07;
    
    [playcard setPositionInPixels:CGPointMake(startx + 300,fixedy)];
    startx -= 5;
    [playcard runAction:[CCMoveTo actionWithDuration:actionTime position:[self posX:startx posY:fixedy]]];
    [NSTimer scheduledTimerWithTimeInterval:(actionTime/2.0) target:self selector:@selector(play_card_sound) userInfo:nil repeats:NO];
    actionTime += 0.07;
    
    //after adding the cards, we have to add right and left buttons
    [left setPositionInPixels:CGPointMake(startx-120 + 300,fixedy)];
    [left runAction:[CCMoveTo actionWithDuration:0.3f position:[self posX:startx-120 posY:fixedy]]];
    actionTime += 0.07;
    
    [right setPositionInPixels:CGPointMake(startx+145 + 300,fixedy)];
    [right runAction:[CCMoveTo actionWithDuration:0.3f position:[self posX:startx+145 posY:fixedy]]];
    
    [buttons reorderChild:left z:topCardZLevel];
    [buttons reorderChild:right z:topCardZLevel];

//    buttons->setEnabled(false);
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //taking the two points from the finger
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    CCLOG(@"Touch ( %f , %f )",touchPos.x,touchPos.y);

    if (buttons != 0) {
        swipeAccepted = false;
        CCMenuItemImage* item = [cardslist objectAtIndex:0];
        CGPoint cardMid = [item position];
        CCLOG(@"Before ( %f , %f )",cardMid.x,cardMid.y);
        cardMid.x = cardMid.x + (winSize.width/2);
        cardMid.y = cardMid.y + (winSize.height/2);
        CCLOG(@"After ( %f , %f )",cardMid.x,cardMid.y);

        if (touchPos.x > (cardMid.x - 100) && touchPos.x < (cardMid.x + 100)) {
            //x position is ok
            if (touchPos.y > (cardMid.y - 150) && touchPos.y < (cardMid.y + 150)) {
                //y position is ok
                swipeAccepted = true;
                startSwipePos = touchPos;
            }
        }
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //taking the two points from the finger
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch1 = [touchesArray objectAtIndex:0];
    CGPoint touchPos = [touch1 locationInView: [touch1 view]];
    touchPos = [[CCDirector sharedDirector] convertToGL:touchPos];
    if (buttons != 0) {
        if (swipeAccepted) {
            if (touchPos.x - startSwipePos.x > 100) {
                swipeAccepted = false;
//                [self left];
            }
            if (touchPos.x - startSwipePos.x < -100) {
                swipeAccepted = false;
//                [self left_2];
            }
        }
    }

    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //taking the two points from the finger
    NSArray *touchesArray = [touches allObjects];
    UITouch *touch1 = [touchesArray objectAtIndex:0];
    CGPoint TouchLoc1 = [touch1 locationInView: [touch1 view]];
    TouchLoc1 = [[CCDirector sharedDirector] convertToGL:TouchLoc1];
    if (buttons == 0) {
        [self remove_aboutUs];
    }
    
}

- (void) play_card_sound {
    [[SimpleAudioEngine sharedEngine] playEffect:@"dealing_card.wav"];
}

- (CGPoint) posX: (float) x posY: (float) y {
    //convert pixel to point point
    float scale = [[CCDirector sharedDirector] winSize].width / [[CCDirector sharedDirector] winSizeInPixels].width;
    x *= scale;
    y *= scale;
    return CGPointMake(x, y);
}

-  (CCLayer*) getMain {
    return main;
}

- (void) createTwitterButton {
    CCMenuItemImage* twitterButton = [CCMenuItemImage itemFromNormalImage:@"t.png" selectedImage:@"t.png" target:self selector:@selector(followUsOnTwitter)];
    CCMenuItemImage* contactUsButton = [CCMenuItemImage itemFromNormalImage:@"m.png" selectedImage:@"m.png" target:self selector:@selector(contactUs)];
    CCMenuItemImage* ourSiteButton = [CCMenuItemImage itemFromNormalImage:@"w.png" selectedImage:@"w.png" target:self selector:@selector(ourSite)];
    CCMenu* twitterMenu = [CCMenu menuWithItems:twitterButton, contactUsButton, ourSiteButton, nil];
    [main addChild:twitterMenu];
    [twitterMenu setPosition:CGPointMake(0, 0)];
    [twitterButton setPositionInPixels:CGPointMake(0,-(((winSizeInPixels.height/2)-([twitterButton contentSizeInPixels].height/1.5))/([self scale])))];
    [ourSiteButton setPositionInPixels:CGPointMake([ourSiteButton contentSizeInPixels].width,[twitterButton positionInPixels].y)];
    [contactUsButton setPositionInPixels:CGPointMake([ourSiteButton positionInPixels].x*-1,[twitterButton positionInPixels].y)];
}

- (void) followUsOnTwitter {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    NSString *urlString = [NSString stringWithFormat:@"http://twitter.com/COMPASSGAMES"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}

- (void) ourSite {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    NSString *urlString = [NSString stringWithFormat:@"http://www.compassgames.net/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}

@end
