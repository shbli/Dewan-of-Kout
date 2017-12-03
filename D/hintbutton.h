//
//  template_cclayer_class.h
//  Arabs Island Cocos2D
//
//  Created by q8phantom on 6/18/11.
//  Copyright 2011 q8spirit. All rights reserved.
//

// replace any template_cclayer_class with class name

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface hintbutton : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    CCSprite* light;
    bool contFlashing;
    float flashingSpeed;
}

-(void)hintButtonClicked;
-(void) flash:(float) time;
-(void) actualFlashing;
-(void) stopFlashing;
@end
