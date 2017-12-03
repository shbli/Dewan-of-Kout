#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "manu_2.h"
#include "loading.h"
#import "fadeDel.h"

@class manu_2;

@interface homeconfmsg : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    manu_2* fath;
}

-(id) initWithFather:(manu_2*) father;
-(void) ok;
-(void) cancel;

@end
