#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "global_keys.h"
#import "SimpleAudioEngine.h"
#import "fadeDel.h"
#import "main_menu.h"
#import "loading.h"

#define fadTime 0.2
#define halfOpacity 100
#define fullOpacity 255

@class main_menu;

@interface pre_playnow : CCLayer {
    CGSize winSize;         //save window size here
    CGSize winSizeInPixels;         //save the window size in pixels instead
    CCMenuItemImage *easy;
    CCMenuItemImage *medium;
    CCMenuItemImage *hard;
    CCMenuItemImage *slow;
    CCMenuItemImage *midSpeed;
    CCMenuItemImage *fast;
    CCMenuItemImage *fifty;
    CCMenuItemImage *hundered;
    CCMenuItemImage *twentyFive;
    CCMenuItemImage *red;
    CCMenuItemImage *blue;
    CCMenuItemImage *silver;
    CCMenuItemImage *okButton;
    CCMenuItemImage *cancelButton;
    main_menu* father;

}

- (id) initWithDad: (main_menu*) dad;
- (void) ok_clicked;
- (void) cacel_clicked;
- (void) blue_clicked;
- (void) red_clicked;
- (void) silver_clicked;
- (void) hard_clicked;
- (void) medium_clicked;
- (void) easy_clicked;
- (void) medium_speed_clicked;
- (void) slow_speed_clicked;
- (void) fast_speed_clicked;
- (void) hundred_clicked;
- (void) fifty_clicked;
- (void) twentyFive_clicked;

@end
