//
//  TopViewController.m
//  RSSReader
//
//  Created by Asmodeus on 11/06/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TopViewController.h"
#import "WebViewController.h"


@implementation TopViewController

@synthesize rssTable, activityIndicator;

WebViewController *webVC;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rssList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    }
    
    int rssIndex = [indexPath indexAtPosition:[indexPath length] - 1 ];
    [cell.textLabel setText:[[rssList objectAtIndex:rssIndex] objectForKey:@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int rssIndex = [indexPath indexAtPosition:[indexPath length] -1];
    
    NSString *rssLink = [[rssList objectAtIndex:rssIndex] objectForKey:@"link"];
    
    rssLink = [rssLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    rssLink = [rssLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    rssLink = [rssLink stringByReplacingOccurrencesOfString:@"　" withString:@""];
    
    NSLog(@"link: %@", rssLink);
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rssLink]];
    webVC = [[WebViewController alloc] initWithNibName:@"webViewController" bundle:nil];
    
    NSURL *outputURL = [NSURL URLWithString:rssLink];
    webVC.callURL = outputURL;
    [self.view addSubview:webVC.view];
    
                         
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (IBAction) rssRead {
    if ([rssList count] == 0) {
        NSString *URL = @"http://feeds.feedburner.com/think-it?q=rss/index.xml";
        rssList = [[NSMutableArray alloc] init];
        NSURL *xmlURL = [NSURL URLWithString:URL];
        
        rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
        
        [rssParser setDelegate:self];
        
        [rssParser setShouldProcessNamespaces:NO];
        [rssParser setShouldReportNamespacePrefixes:NO];
        [rssParser setShouldResolveExternalEntities:NO];
        
        [rssParser parse];
    }
    
    cellsize = CGSizeMake([rssTable bounds].size.width, 60);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"found file and started parsing");
    [activityIndicator startAnimating];
    [activityIndicator setHidden:FALSE];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString *errorString = [NSString stringWithFormat:@"Unable to download rss feed from website (Error code %i )", [parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
           
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
           
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"found this element: %@", elementName);
    
    currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        currentTitle = [[NSMutableString alloc] init];
        currentDate = [[NSMutableString alloc] init];
        currentSummary = [[NSMutableString alloc] init];
        currentLink = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"ended element: %@", elementName);
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:currentTitle forKey:@"title"];
        [item setObject:currentLink forKey:@"link"];
        [item setObject:currentSummary forKey:@"summary"];
        [item setObject:currentDate forKey:@"date"];
        
        [rssList addObject:[item copy]];
        NSLog(@"adding rss: %@", currentTitle);
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"found characters %@", string);
    if ([currentElement isEqualToString:@"title"]) {
        [currentTitle appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [currentLink appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [currentSummary appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
        [currentDate appendString:string];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:TRUE];
    
    NSLog(@"all done");
    NSLog(@"rssList array has %d items", [rssList count]);
    [rssTable reloadData];
     
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentElement release];
    [rssParser release];
    [rssList release];
    [item release];
    [currentTitle release];
    [currentDate release];
    [currentSummary release];
    [currentLink release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
