#import "numbers.h"


@implementation numbers

@synthesize pre;

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
	delete digit;
    [super dealloc];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        digit = new CCSprite*[3];
        //logging puporse prefered to not be removed, and it doesn't affect the perfomance at all
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd),self);
        winSize = [[CCDirector sharedDirector] winSize];                //save window size inside the variable
        winSizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];            //saving window size in pixels other than points
        //here start doing the init stuff        
        for (int i = 0; i < 3; i++) {
            digit[i] = 0;
        }
        [self setContentSize:CGSizeMake(0, 0)];
        pre = @"";
	}
	return self;
}


//end of important for every class that inherits from CCLayer

- (void) setNum:(int)num {
    //deleting any old numbers that exisits
    for (int i = 0; i < 3; i++) {
        if (digit[i] != 0) {
            [self removeChild:digit[i] cleanup:YES];
            digit[i] = 0;
        }
    }
    //adding numbers to that layer
    //the first case, is that we have a number that is less than 10
    if (num >= 0 && num < 10) {
        digit[0] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,num]];
        [self addChild:digit[0]];
    } else if (num >= 10 && num < 100) {
        digit[0] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,num%10]];
        digit[1] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,num/10]];
        [self addChild:digit[0]];
        [self addChild:digit[1]];
        [digit[0] setPositionInPixels:CGPointMake([digit[0] contentSizeInPixels].width/2, 0)];
        [digit[1] setPositionInPixels:CGPointMake(- [digit[1] contentSizeInPixels].width/2, 0)];
        
    } else if (num >= 100 && num < 1000) {
        digit[0] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,num%10]];
        digit[1] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,(num/10)%10]];
        digit[2] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%i.png",pre,num/100]];
        [self addChild:digit[0]];
        [self addChild:digit[1]];
        [self addChild:digit[2]];
        [digit[0] setPositionInPixels:CGPointMake([digit[0] contentSizeInPixels].width, 0)];
        [digit[1] setPositionInPixels:CGPointMake(0, 0)];
        [digit[2] setPositionInPixels:CGPointMake(- [digit[2] contentSizeInPixels].width, 0)];
    } else if (num == -1) {
        //that's the special case meaning pass
        digit[0] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"p.png"]];
        [self addChild:digit[0]];
    }else {
        CCLOG(@"Out of range number in class numbers, number requested more than 1000 it's %i",num);
    }
}

- (void) setOpacity:(int)opac time:(float)time {
    for (int i = 0; i < 3; i++) {
        if (digit[i] != 0) {
            [digit[i] runAction:[CCFadeTo actionWithDuration:time opacity:opac]];
        }
    }
}

@end
