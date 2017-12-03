#import "fadeDel.h"


@implementation fadeDel

- (void) initWithToDel: (CCNode*) toDelete parent: (CCNode*) parent action:(CCFiniteTimeAction*) ac {
    toDel = toDelete;
    p = parent;
    CCSequence* seq = [CCSequence actions: ac ,[CCCallFunc actionWithTarget:self selector:@selector(step_2)], nil];
    [toDelete runAction:seq];
}

- (void) step_2 {
    [p removeChild:toDel cleanup:YES];
    [self autorelease];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    
	// don't forget to call "super dealloc"
	
    [super dealloc];
}




//end of important for every class that inherits from CCLayer


@end
