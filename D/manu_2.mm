#import "manu_2.h"


@implementation manu_2

@synthesize menu;

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
    [self setPositionInPixels:CGPointMake(0, 0)];
//    [self setScale:0.25];
    if (tut) {
        self.isTouchEnabled = true;
    }
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
	manu_2 *layer = [manu_2 node];
	
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
        [self setContentSize:CGSizeMake(0, 0)];
        backGroundHeight = winSizeInPixels.width/origwallw*origwallh;
        
        main = [CCLayer node];
        [self addChild:main];

        
        int diffID = [[NSUserDefaults standardUserDefaults] integerForKey:diffculty_key];
        int speedVal = [[NSUserDefaults standardUserDefaults] integerForKey:gamespeed_key];
        int gaidVal = [[NSUserDefaults standardUserDefaults] integerForKey:gaidtotal_key];
        int themeVal = [[NSUserDefaults standardUserDefaults] integerForKey:theme_key];
        
        //we'll start by adding a sprite that represents the background for the menu
        if (themeVal == redID) {
            background = [CCSprite spriteWithFile:@"Carpet_Red.png"];
        } else if (themeVal == blueID){
            background = [CCSprite spriteWithFile:@"Carpet_Blue.png"];
        } else {
            background = [CCSprite spriteWithFile:@"Carpet_Silver.png"];
        }
        [background setScale:(winSizeInPixels.width/origwallw)];
        [background setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:background];
        
        
        //sofas
        
        sofa_top = [CCSprite spriteWithFile:@"Sofa_Up.png"];
        [sofa_top setScale:[background scale]];
        [sofa_top setPositionInPixels:CGPointMake(winSizeInPixels.width/2,winSizeInPixels.height-(([sofa_top contentSizeInPixels].height*[sofa_top scale])/2)) ];
        [main reorderChild:sofa_top z:10];
        [main addChild:sofa_top];
        
        sofa_left = [CCSprite spriteWithFile:@"Sofa_R_L.png"];
        [sofa_left setScale:[background scale]];
        [sofa_left setPositionInPixels:CGPointMake((([sofa_left contentSizeInPixels].width*[sofa_left scale])/2),winSizeInPixels.height/2)];
        [main reorderChild:sofa_left z:10];
        [main addChild:sofa_left];
        
        
        sofa_small_left = [CCSprite spriteWithFile:@"Sofa_Small_R_L.png"];
        [sofa_small_left setRotation:180];
        [sofa_small_left setScale:[background scale]];
        [sofa_small_left setPositionInPixels:CGPointMake((([sofa_small_left contentSizeInPixels].width*[sofa_small_left scale])/2),winSizeInPixels.height/2)];
        [main reorderChild:sofa_small_left z:10];
        [main addChild:sofa_small_left];
        
        sofa_right = [CCSprite spriteWithFile:@"Sofa_R_L.png"];
        [sofa_right setRotation:180];
        [sofa_right setScale:[background scale]];
        [sofa_right setPositionInPixels:CGPointMake(winSizeInPixels.width - (([sofa_right contentSizeInPixels].width*[sofa_right scale])/2),winSizeInPixels.height/2)];
        [main reorderChild:sofa_right z:10];
        [main addChild:sofa_right];
        
        
        sofa_small_right = [CCSprite spriteWithFile:@"Sofa_Small_R_L.png"];
        [sofa_small_right setScale:[background scale]];
        [sofa_small_right setPositionInPixels:CGPointMake(winSizeInPixels.width - (([sofa_small_left contentSizeInPixels].width*[sofa_small_left scale])/2),winSizeInPixels.height/2)];
        [main reorderChild:sofa_small_right z:10];
        [main addChild:sofa_small_right];
        
        sofa_bottom = [CCSprite spriteWithFile:@"Sofa_Down.png"];
        [sofa_bottom setScale:[background scale]];
        [sofa_bottom setPositionInPixels:CGPointMake(winSizeInPixels.width/2,([sofa_bottom contentSizeInPixels].height*[sofa_bottom scale])/2)];
        [main reorderChild:sofa_bottom z:20];
        [main addChild:sofa_bottom];
        
        CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage:@"home_main.png" selectedImage:@"home_main_clicked.png" target:self selector:@selector(clickedTest)];
        menu = [CCMenu menuWithItems:item, nil];
        [main addChild:menu];
        [main reorderChild:menu z:20];
        [menu setPositionInPixels:CGPointMake(0, 0)];
        [item setScale:[background scale]];
        [item setPositionInPixels:CGPointMake([item contentSizeInPixels].width * [item scale] / 2, [item contentSizeInPixels].height * [item scale] / 2)];
        
        
        CCSprite *goldenTeamScore = [CCSprite spriteWithFile:@"golden_team_score.png"];
        [goldenTeamScore setScale: [background scale]];
        [goldenTeamScore setPositionInPixels:CGPointMake(([goldenTeamScore contentSizeInPixels].width*[goldenTeamScore scale]/2),winSizeInPixels.height-([goldenTeamScore contentSizeInPixels].height*[goldenTeamScore scale]/2))];
        if ([goldenTeamScore positionInPixels].y - ([goldenTeamScore contentSizeInPixels].height*[goldenTeamScore scale]/2) < [sofa_left positionInPixels].y + ([sofa_left contentSizeInPixels].height*[sofa_left scale]/2)) {
            //we have a problem here, it's just a small problem, we'll fix it
            [goldenTeamScore setPositionInPixels:CGPointMake([goldenTeamScore positionInPixels].x, [goldenTeamScore positionInPixels].y - (([goldenTeamScore positionInPixels].y - ([goldenTeamScore contentSizeInPixels].height*[goldenTeamScore scale]/2) - ([sofa_left positionInPixels].y + ([sofa_left contentSizeInPixels].height*[sofa_left scale]/2)))/2) )];
        }
        [main addChild:goldenTeamScore];
        [main reorderChild:goldenTeamScore z:21];
        CCSprite *silverTeamScore = [CCSprite spriteWithFile:@"silver_team_score.png"];
        [silverTeamScore setScale:[background scale]];
        [silverTeamScore setPositionInPixels:CGPointMake(winSizeInPixels.width - ([silverTeamScore contentSizeInPixels].width*[silverTeamScore scale]/2),[goldenTeamScore positionInPixels].y)];
        [main addChild:silverTeamScore];
        [main reorderChild:silverTeamScore z:21];
        scoreH = ([silverTeamScore contentSizeInPixels].height*[silverTeamScore scale]/2) + (winSizeInPixels.height - [silverTeamScore positionInPixels].y);
        
        if (!tut) {
            gameDealer = [[dealer alloc] initWithTut:tut scoreH:scoreH gaid:gaidVal speed:speedVal diffcult:diffID parent:self];
        }
        else {
            gameDealer = [[dealer alloc] initWithTut:tut scoreH:scoreH gaid:101 speed:3 diffcult:easyID parent:main];
        }
        float x = winSizeInPixels.width/2;
        float y = winSizeInPixels.height/2;
        [gameDealer setPositionInPixels:CGPointMake(x, y)];
        [main addChild:gameDealer];
        if (!tut) {
            bool UITut = [[NSUserDefaults standardUserDefaults] boolForKey:uiTut_key];
            if (UITut) {
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:uiTut_key];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.isTouchEnabled = true;
                [self showNextPage];
            } else {
                [gameDealer dealcards];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:uiTut_key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            pageNum = 0;
            [self showNextPage];
        }
        [main setContentSize:CGSizeMake(0, 0)];
        CCLOG(@"main %f,%f",main.anchorPointInPixels.x,main.anchorPointInPixels.y);
        CCLOG(@"gameDealer %f,%f",gameDealer.anchorPointInPixels.x,gameDealer.anchorPointInPixels.y);
        CCLOG(@"self %f,%f",self.anchorPointInPixels.x,self.anchorPointInPixels.y);
        [main reorderChild:gameDealer z:21];
        [self reorderChild:background z:-200];
	}
	return self;
}

//end of important for every class that inherits from CCLayer

+(void) setTut:(BOOL)val {
    tut = val;
}

-(void) showNextPage {
    pageNum++;
    int langID = [[NSUserDefaults standardUserDefaults] integerForKey:langkey];
    int totalPages = 3;
    if (tut) {
        totalPages = 9;
    }
    if (pageNum < totalPages + 1) {
        NSString* nextFileName;
        if (langID == arabic) {
            if (tut) {
                nextFileName = [NSString stringWithFormat:@"%i_tut_start_ar.png",pageNum];
            } else {
                nextFileName = [NSString stringWithFormat:@"%i_interface_tut_ar.png",pageNum];
            }
        } else {
            if (tut) {
                nextFileName = [NSString stringWithFormat:@"%i_tut_start.png",pageNum]; 
            } else {
                nextFileName = [NSString stringWithFormat:@"%i_interface_tut.png",pageNum]; 
            }
        }
        [gameDealer players:0]->tutMessageSprite = [CCSprite spriteWithFile:nextFileName];
        [gameDealer players:0]->show_tut_message();
    } else {
        self.isTouchEnabled = false;
        [gameDealer dealcards];
    }

}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [gameDealer players:0]->hide_tut_message();
    [self showNextPage];
}

-(void) clickedTest {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button-click.wav"];
    menu.isTouchEnabled = false;
    homeconfmsg* configLayer = [[homeconfmsg alloc] initWithFather:self];
    [main addChild:configLayer];
    [configLayer setScale:[background scale]];
    [main reorderChild:configLayer z:onTopOfDealerZvalue];
    [configLayer setPositionInPixels:CGPointMake(winSizeInPixels.width*2, winSizeInPixels.height/2)];
    [configLayer runAction:[CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(winSize.width/2, winSize.height/2)] rate:4]];
    
}


@end
