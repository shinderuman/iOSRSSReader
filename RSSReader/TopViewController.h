//
//  TopViewController.h
//  RSSReader
//
//  Created by Asmodeus on 11/06/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopViewController : UIViewController <NSXMLParserDelegate> {
    UITableView *rssTable;
    UIActivityIndicatorView *activityIndicator;
    CGSize cellsize;
    NSXMLParser *rssParser;
    NSMutableArray *rssList;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *currentTitle, *currentDate, *currentSummary, *currentLink;
}

@property (nonatomic,retain) IBOutlet UITableView *rssTable;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction) rssRead;

@end
