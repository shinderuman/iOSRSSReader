//
//  WebViewController.h
//  RSSReader
//
//  Created by Asmodeus on 11/06/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
    UIWebView *web;
    NSURL *callURL;
}
@property(nonatomic,retain) IBOutlet UIWebView *web;
@property(nonatomic,retain) IBOutlet NSURL *callURL;

- (IBAction) listBack;

@end
