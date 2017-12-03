//
//  template_cclayer_class.m
//  Arabs Island Cocos2D
//
//  Created by q8phantom on 6/18/11.
//  Copyright 2011 q8spirit. All rights reserved.
//


//replace every template_cclayer_class with class name

#import "rvwgmmsg.h"


@implementation rvwgmmsg



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
        zOrder_ = 40;
        //this creates a menu with two buttons, ok and cancel
        QString message;
        QString ok;
        QString ok_clicked;
        QString cancel;
        QString cancel_clicked;
        QString later;
        QString later_clicked;
        int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
        if (langID == arabic) {
            message = @"review_message_ar.png";
            ok = @"review_now_ar.png";
            cancel = @"dont_remind_me_ar.png";
            ok_clicked = @"review_now_ar_clicked.png";
            cancel_clicked = @"dont_remind_me_ar_clicked.png";
            later = @"later_ar.png";
            later_clicked = @"later_ar_clicked.png";
        } else {
            //anything unnormal, we'll just make it english
            message = @"review_message_en.png";
            ok = @"review_now_en.png";
            cancel = @"dont_remind_me_en.png";
            ok_clicked = @"review_now_en_clicked.png";
            cancel_clicked = @"dont_remind_me_en_clicked.png";
            later = @"later_en.png";
            later_clicked = @"later_en_clicked.png";
        }
        
        CCSprite* messagesprite = [CCSprite spriteWithFile:message];
        CCMenuItemImage *okbutton = [CCMenuItemImage itemFromNormalImage:ok selectedImage:ok_clicked target:self selector:@selector(reviewNow)];
        CCMenuItemImage *cancelbutton = [CCMenuItemImage itemFromNormalImage:cancel selectedImage:cancel_clicked target:self selector:@selector(dontRemindMe)];
        CCMenuItemImage *laterbutton = [CCMenuItemImage itemFromNormalImage:later selectedImage:later_clicked target:self selector:@selector(laterTime)];
        CCMenu* menu = [CCMenu menuWithItems:okbutton,cancelbutton,laterbutton, nil];
        [menu setPosition:CGPointMake(0, 0)];
        [self addChild:menu];
        [self addChild:messagesprite];
        [self setContentSize:CGSizeMake(0, 0)];
        [menu setContentSize:CGSizeMake(0, 0)];
        [messagesprite setPositionInPixels:CGPointMake(0,[messagesprite contentSizeInPixels].height)];
        [okbutton setPositionInPixels:CGPointMake(0,[messagesprite positionInPixels].y - ( ([messagesprite contentSizeInPixels].height/2) + ([okbutton contentSizeInPixels].height/2) ) + 1)];
        [cancelbutton setPositionInPixels:CGPointMake(0,[okbutton positionInPixels].y - ( ([cancelbutton contentSizeInPixels].height/2) + ([okbutton contentSizeInPixels].height/2) ) + 1)];
        [laterbutton setPositionInPixels:CGPointMake(0,[cancelbutton positionInPixels].y - ( ([cancelbutton contentSizeInPixels].height/2) + ([laterbutton contentSizeInPixels].height/2) ) + 1)];
	}
	return self;
}

- (void) reviewNow {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    //free id 502866144
#ifdef freeVersion
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=502866144&pageNumber=0& sortOrdering=1&type=Purple+Software&mt=8"];
#endif
#ifndef freeVersion
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=491157833&pageNumber=0& sortOrdering=1&type=Purple+Software&mt=8"];    
#endif
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"reviewcount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[fadeDel alloc] initWithToDel:self parent:self.parent action:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:0] rate:4]];
}

- (void) laterTime {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"reviewcount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[fadeDel alloc] initWithToDel:self parent:self.parent action:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:0] rate:4]];
    

}

- (void) dontRemindMe {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"reviewcount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[fadeDel alloc] initWithToDel:self parent:self.parent action:[CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:0] rate:4]];
}


//end of important for every class that inherits from CCLayer


@end
