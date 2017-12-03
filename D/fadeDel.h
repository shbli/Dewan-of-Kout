#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface fadeDel : NSObject  {
    CCNode* p;
    CCNode *toDel;
}

- (void) initWithToDel: (CCNode*) toDelete parent: (CCNode*) parent action:(CCFiniteTimeAction*) ac;
- (void) step_2;
@end
