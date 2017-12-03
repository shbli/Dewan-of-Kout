#import "callmenu.h"


@implementation callmenu

@synthesize wholeMenu;

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
-(id) initWithDealer:(dealer *)deal playerID:(int)playerID call:(BOOL)callB
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
        pid = playerID;
        gameDealer = deal;
        
        CCMenuItemImage *call_5;
        CCMenuItemImage *call_6;
        CCMenuItemImage *call_7;
        CCMenuItemImage *call_8;
        CCMenuItemImage *call_9;
        CCMenuItemImage *call_pass;
        if (callB) {
            //here, we choosed the call menu
            //middle
            //specific arabic or english file may be soecified later, just uncomment the code
            NSString* passButton;
            NSString* passButton_clicked;
            
            int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
            if (langID == arabic) {
                passButton = @"callMenu_pass.png";
                passButton_clicked = @"callMenu_pass_pressed.png";
            } else {
                passButton = @"callMenu_pass_e.png";
                passButton_clicked = @"callMenu_pass_pressed_e.png";
            }
            //down middle
            if ([gameDealer bed].amout < 6) {
                call_6 = [CCMenuItemImage itemFromNormalImage:@"callMenu_6.png" selectedImage:@"callMenu_6_pressed.png" target:self selector:@selector(call_6_clicked)]; 
            } else {
                
                call_6 = [CCMenuItemImage itemFromNormalImage:@"callMenu_6_pressed.png" selectedImage:@"callMenu_6_pressed.png"]; 
            }
            //down left
            if ([gameDealer bed].amout < 5) {
                call_5 = [CCMenuItemImage itemFromNormalImage:@"callMenu_5.png" selectedImage:@"callMenu_5_pressed.png" target:self selector:@selector(call_5_clicked)]; 
            } else {
                
                call_5 = [CCMenuItemImage itemFromNormalImage:@"callMenu_5_pressed.png" selectedImage:@"callMenu_5_pressed.png"]; 
            }
            //down right
            if ([gameDealer bed].amout < 7) {
                call_7 = [CCMenuItemImage itemFromNormalImage:@"callMenu_7.png" selectedImage:@"callMenu_7_pressed.png" target:self selector:@selector(call_7_clicked)]; 
            } else {
                
                call_7 = [CCMenuItemImage itemFromNormalImage:@"callMenu_7_pressed.png" selectedImage:@"callMenu_7_pressed.png"]; 
            }
            //up midlle
            call_9 = [CCMenuItemImage itemFromNormalImage:@"callMenu_9.png" selectedImage:@"callMenu_9_pressed.png" target:self selector:@selector(call_9_clicked)]; 
            //up right
            call_pass = [CCMenuItemImage itemFromNormalImage:passButton selectedImage:passButton_clicked target:self selector:@selector(call_pass_clicked)]; 

            //up left
            if ([gameDealer bed].amout < 8) {
                call_8 = [CCMenuItemImage itemFromNormalImage:@"callMenu_8.png" selectedImage:@"callMenu_8_pressed.png" target:self selector:@selector(call_8_clicked)]; 
            } else {
                
                call_8 = [CCMenuItemImage itemFromNormalImage:@"callMenu_8_pressed.png" selectedImage:@"callMenu_8_pressed.png"]; 
            }

            //position the elements
            [call_6 setScale:(winSizeInPixels.width/origwallw)];
            [call_6 setPositionInPixels:CGPointMake(0,(([call_6 contentSizeInPixels].height*[call_6 scale]/2) ))];
            [call_5 setScale:[call_6 scale]];
            [call_5 setPositionInPixels:CGPointMake( - ( ([call_5 contentSizeInPixels].width*[call_5 scale]/2) + ([call_6 contentSizeInPixels].width*[call_6 scale]/2) ) ,[call_6 positionInPixels].y )];
            [call_7 setScale:([call_6 scale])];
            [call_7 setPositionInPixels:CGPointMake( ( ([call_7 contentSizeInPixels].width*[call_7 scale]/2) + ([call_6 contentSizeInPixels].width*[call_6 scale]/2) ) ,[call_6 positionInPixels].y )];
            
            [call_9 setScale:([call_6 scale])];
            [call_9 setPositionInPixels:CGPointMake(0, - (([call_9 contentSizeInPixels].height*[call_9 scale]/2) ))];
            [call_pass setScale:([call_6 scale])];
            [call_pass setPositionInPixels:CGPointMake(  ( ([call_pass contentSizeInPixels].width*[call_pass scale]/2) + ([call_9 contentSizeInPixels].width*[call_9 scale]/2) ) , [call_9 positionInPixels].y )];
            [call_8 setScale:([call_6 scale])];
            [call_8 setPositionInPixels:CGPointMake( - ( ([call_8 contentSizeInPixels].width*[call_8 scale]/2) + ([call_9 contentSizeInPixels].width*[call_9 scale]/2) ) , [call_9 positionInPixels].y )];
            call_5.position = CGPointMake(call_5.position.x+(750*[call_6 scale]), call_5.position.y);
            call_6.position = CGPointMake(call_6.position.x+(750*[call_6 scale]), call_6.position.y);
            call_7.position = CGPointMake(call_7.position.x+(750*[call_6 scale]), call_7.position.y);
            call_8.position = CGPointMake(call_8.position.x+(750*[call_6 scale]), call_8.position.y);
            call_9.position = CGPointMake(call_9.position.x+(750*[call_6 scale]), call_9.position.y);
            call_pass.position = CGPointMake(call_pass.position.x+(750*[call_6 scale]), call_pass.position.y);
            wholeMenu = [CCMenu menuWithItems:call_6,call_5,call_pass,call_9,call_8,call_7, nil];
            [self addChild:wholeMenu];
            
            float speed = 0.1;
            [call_5 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];
            speed+= 0.05;
            [call_6 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];
            speed+= 0.05;
            [call_7 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];
            speed+= 0.05;
            [call_8 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];
            speed+= 0.05;
            [call_9 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];
            speed+= 0.05;
            [call_pass runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_6 scale],0)]];

        } else {
            //here, we choosed the suite chooser menu
            //middle
            //down left
            call_5 = [CCMenuItemImage itemFromNormalImage:@"trumpMenu_d.png" selectedImage:@"trumpMenu_d.png" target:self selector:@selector(club_clicked)]; 
            //down right
            call_7 = [CCMenuItemImage itemFromNormalImage:@"trumpMenu_s.png" selectedImage:@"trumpMenu_s.png" target:self selector:@selector(diamond_clicked)]; 
            //up right
            call_pass = [CCMenuItemImage itemFromNormalImage:@"trumpMenu_h.png" selectedImage:@"trumpMenu_h.png" target:self selector:@selector(spade_clicked)]; 
            //up left
            call_8 = [CCMenuItemImage itemFromNormalImage:@"trumpMenu_c.png" selectedImage:@"trumpMenu_c.png" target:self selector:@selector(heart_clicked)]; 
            
            //position the elements
            //down left
            [call_5 setScale:winSizeInPixels.width/origwallw];
            [call_5 setPositionInPixels:CGPointMake( - ( ([call_5 contentSizeInPixels].width*[call_5 scale]/2)) ,- ( ([call_5 contentSizeInPixels].height*[call_5 scale]/2)  ))];
            //down right
            [call_7 setScale:([call_5 scale])];
            [call_7 setPositionInPixels:CGPointMake( ( ([call_7 contentSizeInPixels].width*[call_5 scale]/2)) ,- ( ([call_7 contentSizeInPixels].height*[call_5 scale]/2) ))];
            
            //up right
            [call_pass setScale:([call_5 scale])];
            [call_pass setPositionInPixels:CGPointMake( ( ([call_pass contentSizeInPixels].width*[call_5 scale]/2)) , ( ([call_pass contentSizeInPixels].height*[call_5 scale]/2) ))];
            //up left
            [call_8 setScale:([call_5 scale])];
            [call_8 setPositionInPixels:CGPointMake( - ( ([call_8 contentSizeInPixels].width*[call_5 scale]/2)) , ( ([call_8 contentSizeInPixels].height*[call_5 scale]/2) ))];
            
            call_5.position = CGPointMake(call_5.position.x+(750*[call_5 scale]), call_5.position.y);
            call_7.position = CGPointMake(call_7.position.x+(750*[call_5 scale]), call_7.position.y);
            call_8.position = CGPointMake(call_8.position.x+(750*[call_5 scale]), call_8.position.y);
            call_pass.position = CGPointMake(call_pass.position.x+(750*[call_5 scale]), call_pass.position.y);

            wholeMenu = [CCMenu menuWithItems:call_5,call_pass,call_8,call_7, nil];
             [self addChild:wholeMenu];
             
             float speed = 0.1;
             [call_pass runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_5 scale],0)]];
            speed+= 0.05;
             [call_8 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_5 scale],0)]];
            speed+= 0.05;
             [call_5 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_5 scale],0)]];
            speed+= 0.05;
             [call_7 runAction:[CCMoveBy actionWithDuration:speed position:CGPointMake(-750*[call_5 scale],0)]];            
        }
        [wholeMenu setPosition:CGPointMake(0, 0)];
        [self setContentSize:CGSizeMake(0, 0)];

	}
	return self;
}

- (void) call_5_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    if ([gameDealer bed].amout < 5) {
        bedding newBed = [gameDealer bed];
        newBed.suite = Card::None;
        newBed.amout = 5;
        newBed.playerID = pid;
        newBed.team = pid%numOfTeams;
        [gameDealer setBed:newBed];
        [gameDealer hideCallMenu];
        [gameDealer players:pid]->speech(5);
        [gameDealer players:pid]->ai_unit.tookTurn = true;
    }

}
- (void) call_6_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    if ([gameDealer bed].amout < 6) {
        bedding newBed = [gameDealer bed];
        newBed.suite = Card::None;
        newBed.amout = 6;
        newBed.playerID = pid;
        newBed.team = pid%numOfTeams;
        [gameDealer setBed:newBed];
        [gameDealer hideCallMenu];
        [gameDealer players:pid]->speech(6);
        [gameDealer players:pid]->ai_unit.tookTurn = true;
    }
    
}
- (void) call_7_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    if ([gameDealer bed].amout < 7) {
        bedding newBed = [gameDealer bed];
        newBed.suite = Card::None;
        newBed.amout = 7;
        newBed.playerID = pid;
        newBed.team = pid%numOfTeams;
        [gameDealer setBed:newBed];
        [gameDealer hideCallMenu];
        [gameDealer players:pid]->speech(7);
        [gameDealer players:pid]->ai_unit.tookTurn = true;
    }
    
}
- (void) call_8_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    if ([gameDealer bed].amout < 8) {
        bedding newBed = [gameDealer bed];
        newBed.suite = Card::None;
        newBed.amout = 8;
        newBed.playerID = pid;
        newBed.team = pid%numOfTeams;
        [gameDealer setBed:newBed];
        [gameDealer hideCallMenu];
        [gameDealer players:pid]->speech(8);
        [gameDealer players:pid]->ai_unit.tookTurn = true;
    }
    
}
- (void) call_9_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    if ([gameDealer bed].amout < 9) {
        bedding newBed = [gameDealer bed];
        newBed.suite = Card::None;
        newBed.amout = 9;
        newBed.playerID = pid;
        newBed.team = pid%numOfTeams;
        [gameDealer setBed:newBed];
        [gameDealer hideCallMenu];
        [gameDealer players:pid]->speech(9);
        [gameDealer players:pid]->ai_unit.tookTurn = true;
    }
    
}
- (void) call_pass_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    [gameDealer hideCallMenu];
    [gameDealer players:pid]->speech(-1);
    [gameDealer players:pid]->ai_unit.tookTurn = true;

}
- (void) heart_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    bedding newBed = [gameDealer bed];
    newBed.suite = Card::Heart;
    [gameDealer setBed:newBed];
    [gameDealer hideCallMenu];

}
- (void) diamond_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    bedding newBed = [gameDealer bed];
    newBed.suite = Card::Diamond;
    [gameDealer setBed:newBed];
    [gameDealer hideCallMenu];
}
- (void) spade_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    bedding newBed = [gameDealer bed];
    newBed.suite = Card::Spade;
    [gameDealer setBed:newBed];
    [gameDealer hideCallMenu];
}
- (void) club_clicked {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    bedding newBed = [gameDealer bed];
    newBed.suite = Card::Club;
    [gameDealer setBed:newBed];
    [gameDealer hideCallMenu];
}



//end of important for every class that inherits from CCLayer





@end
