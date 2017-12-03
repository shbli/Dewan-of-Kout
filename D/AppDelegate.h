//
//  AppDelegate.h
//  D
//
//  Created by Ahmed Al Shebli on 12/15/11.
//  Copyright GUST 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
