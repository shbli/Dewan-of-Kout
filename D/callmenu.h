#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "dealer.h"
#import "global_keys.h"
#import "SimpleAudioEngine.h"
//@class dealer;

@interface callmenu : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    dealer* gameDealer;
    int pid;
    CCMenu* wholeMenu;
    
}

@property (nonatomic,retain) CCMenu* wholeMenu;

-(id) initWithDealer:(dealer*) deal playerID:(int) playerID call:(BOOL) callB;
- (void) call_5_clicked;
- (void) call_6_clicked;
- (void) call_7_clicked;
- (void) call_8_clicked;
- (void) call_9_clicked;
- (void) call_pass_clicked;
- (void) heart_clicked;
- (void) diamond_clicked;
- (void) spade_clicked;
- (void) club_clicked;

@end
