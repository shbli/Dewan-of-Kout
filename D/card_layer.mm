#import "card_layer.h"


@implementation card_layer

@synthesize cardInst;

//important for every class that inherits from CCLayer

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
    
	// don't forget to call "super dealloc"
    delete cardInst;

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


//end of important for every class that inherits from CCLayer

- (id) initWithFile:(NSString *)cardfile type:(Card::cardType) type number :(int)cardNumber {
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff
        back = [CCSprite spriteWithFile:@"cardback.png"];
        front = [CCSprite spriteWithFile:cardfile];
        white = [CCSprite spriteWithFile:@"white_layer.png"];
        black = [CCSprite spriteWithFile:@"blacklayer.png"];
        [front setOpacity:0];
        [white setOpacity:0];
        [black setOpacity:0];
        [self reorderChild:white z:1];
        [self reorderChild:black z:1];
        faceDown = true;
        cardInst = new Card(type,cardNumber);
        [self addChild:back];
        [self addChild:front];
        [self addChild:black];
        [self addChild:white];
        [self setContentSize:CGSizeMake(0, 0)];
        [front setVisible:NO];
        [black setVisible:NO];
        [white setVisible:NO];
	}
	return self;
}

- (void) turnFaceDown:(float)time {
    if (!faceDown) {
        [back setVisible:YES];
        [back stopAllActions];
        [front stopAllActions];
        [back runAction:[CCSequence actions:[CCFadeTo actionWithDuration:time opacity:255],[CCCallFunc actionWithTarget:self selector:@selector(faceDownDone)], nil]];
        [front runAction:[CCFadeTo actionWithDuration:time opacity:0]];
        faceDown = true;
    }
}

- (void) turnFaceUp:(float)time {
    if (faceDown) {
        [front setVisible:YES];
        [back stopAllActions];
        [front stopAllActions];
        [back runAction:[CCFadeTo actionWithDuration:time opacity:0]];
        [front runAction:[CCSequence actions:[CCFadeTo actionWithDuration:time opacity:255],[CCCallFunc actionWithTarget:self selector:@selector(faceUpDone)], nil]];
        faceDown = false;
    }
}

-(void) faceUpDone {
    [back setVisible:NO];
}

-(void) faceDownDone {
    [front setVisible:NO];
}

- (BOOL) cardWithPlayer {
    return cardInst->cardWithPlayer();
}
- (BOOL) cardWithDealer {
    return cardInst->cardWithDealer();
}

- (void) giveCardToPlayer : (int) ID {
    cardInst->giveCardToPlayer(ID);
}

- (int) player_id_holding_card {
    return cardInst->player_id_holding_card();
}

- (void) returnCardToDealer {
    cardInst->returnCardToDealer();
}

- (float) cardWidth {
    return [back contentSizeInPixels].width;
}

-(float) cardHeight {
    return [back contentSizeInPixels].height;
}



- (void) dim:(float)time {
    [black setVisible:YES];
    [black stopAllActions];
    [black runAction:[CCFadeTo actionWithDuration:time opacity:255]];
}

-(void) undim:(float)time {
    [black stopAllActions];
    [black runAction:[CCSequence actions:[CCFadeTo actionWithDuration:time opacity:0],[CCCallFunc actionWithTarget:self selector:@selector(setBlackNotVisiable)],nil]];
}

-(void) flash:(float)time WithTarget:(id)next selector:(SEL)slot {
    [white stopAllActions];
    [white setVisible:YES];
    if (next != 0) {
        [white runAction:[CCSequence actions:[CCFadeTo actionWithDuration:time/4 opacity:255],[CCFadeTo actionWithDuration:time/4 opacity:0]
                          ,[CCFadeTo actionWithDuration:time/4 opacity:255],[CCFadeTo actionWithDuration:time/4 opacity:0],[CCCallFunc actionWithTarget:self selector:@selector(setWhiteNotVisiable)],[CCCallFunc actionWithTarget:next selector:slot], nil]];
    } else {
        [white runAction:[CCSequence actions:[CCFadeTo actionWithDuration:time/4 opacity:255],[CCFadeTo actionWithDuration:time/4 opacity:0]
                          ,[CCFadeTo actionWithDuration:time/4 opacity:255],[CCFadeTo actionWithDuration:time/4 opacity:0],[CCCallFunc actionWithTarget:self selector:@selector(setWhiteNotVisiable)],nil]];
    }
}

- (BOOL) contains:(CGPoint)testPoint {
    CGPoint pos = [self positionInPixels];
    pos.x = pos.x + (winSizeInPixels.width/2);
    pos.y = pos.y + (winSizeInPixels.height/2);
    float scale = [self scale];
    //let's take the conditions if the point is within the card we'll return true
    if (testPoint.x >= (pos.x-([self cardWidth]*scale/2)) )
        if (testPoint.x <= (pos.x+([self cardWidth]*scale/2)) )
            if (testPoint.y >= (pos.y-(([self cardHeight]*scale)/2)) )
                if (testPoint.y <= (pos.y+([self cardHeight]*scale)/2))
                    return true;
    
    //condition not met, return false
    return false;

}

-(void) setBlackNotVisiable {
    [black setVisible:NO];
}

-(void) setWhiteNotVisiable {
    [white setVisible:NO];
}

-(void) setZ:(int)zValue {
    [parent_ reorderChild:self z:zValue];
}

@end
