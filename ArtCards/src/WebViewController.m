//
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
// private methods
- (void) showFacebookPage;
@end

@implementation WebViewController

@synthesize myWebView;
@synthesize isFacebookHome;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.delegate=self;

    if (self.isFacebookHome) {
        [self showFacebookPage];
    }
}

- (IBAction)buttonPressedBack:(id)sender {    
    [self viewDidUnload];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)buttonPressedInstructions:(id)sender {
	myWebView.hidden = YES;
}

- (IBAction)buttonPressedvbOnline:(id)sender {
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.vectorbloom.com"]]];
    myWebView.hidden = NO;
}

- (IBAction)buttonPressedtwitterAccount:(id)sender {
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.twitter.com/vectorbloom"]]];	
	myWebView.hidden = NO;
}

- (IBAction)buttonPressedfacebookPage:(id)sender {
    [self showFacebookPage];
}

-(void)showFacebookPage {
    NSString *url;
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"everPostedToFacebook"] )  {  // if posted to Facebook sometime before
        url = @"http://m.facebook.com";
    } else {
        url = @"http://m.facebook.com/artcardsbyelizabethboylan";
    }
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    myWebView.hidden = NO;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] initWeb];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@" "];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
}


// Override to allow orientations other than the default portrait orientation.

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
			(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.myWebView = nil;
}

- (void)dealloc {
    [myWebView release];
    [super dealloc];
}

@end
