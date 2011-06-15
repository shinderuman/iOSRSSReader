//
//  RSSReaderAppDelegate.h
//  RSSReader
//
//  Created by Asmodeus on 11/06/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSReaderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *naviController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *naviController;

@end
