//
//  Created by Elizabeth Boylan on 11-02-20.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//

#import "CustomizeArtCardView.h"
#import "WebViewController.h"
#import "FBFriendsViewController.h"
#import <Twitter/Twitter.h>

@interface CustomizeArtCardView ()
// private methods
- (void)MMSogram;
- (void)facebookPostToMe;
- (void)facebookGetFriends;
- (UIImage *)getScreenShot;
- (void)hideToolbarAndMaybeText;
- (void)showToolbarAndText;
- (void)saveToPhotos;
@end


@implementation CustomizeArtCardView

@synthesize greetingImage;
@synthesize greetingText;
@synthesize clearButton;
@synthesize fontButton;
@synthesize toolBar;
@synthesize isChangedGreetingText;
@synthesize isInGreetingText;

@synthesize actionButton;
@synthesize actionPopoverController;
@synthesize fontPopoverController;

@synthesize artCardDict;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    // Add a pinch gesture recognizer to the view.
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.greetingText addGestureRecognizer:pinchRecognizer];
    [pinchRecognizer release];
    
    
    // Add panning to textview
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textviewDragged:)];
	[self.greetingText addGestureRecognizer:panRecognizer];
    [panRecognizer release];

/*
    // Add rotate gesture to textview with this code
 
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(textviewRotate:)];
	[self.greetingText addGestureRecognizer:rotationRecognizer];
    [rotationRecognizer release];
*/    
    
	UIImage *newImage = [UIImage imageNamed:[artCardDict objectForKey:@"imageFull"]];
	greetingImage.image = newImage;
	[newImage release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];	// object:[self view].window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    // List all fonts on iPhone by temporarily uncommenting this code
    // The iPhone app 'Typefaces' is excellent for viewing your iPhone fonts
    // The 'Postscript Name' attribute in the Typefaces app is the font name that goes in the Fonts.plist
    // to add new fonts in the fonts list
    
/*
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
*/
    

	isChangedGreetingText = NO;
    isInGreetingText = NO;
	
	imagePasteboard = [UIPasteboard generalPasteboard];
    
    greetingText.font = [UIFont fontWithName:[artCardDict objectForKey:@"fontName"] size:[[artCardDict objectForKey:@"fontSize"] floatValue]];
	greetingText.delegate = self;
    
    if ([[artCardDict objectForKey:@"textAlignment"] isEqualToString:@"Left"]) {
        greetingText.textAlignment = UITextAlignmentLeft;
    } if ([[artCardDict objectForKey:@"textAlignment"] isEqualToString:@"Center"]) {
        greetingText.textAlignment = UITextAlignmentCenter;
    } else if ([[artCardDict objectForKey:@"textAlignment"] isEqualToString:@"Right"]) {
        greetingText.textAlignment = UITextAlignmentRight;
    }    

    NSDictionary *textRGBADict = [artCardDict objectForKey:@"textRGBA"];
    
    CGFloat textR = [[textRGBADict objectForKey:@"1_Red"]   floatValue];
    CGFloat textG = [[textRGBADict objectForKey:@"2_Green"] floatValue];
    CGFloat textB = [[textRGBADict objectForKey:@"3_Blue"]  floatValue];
    CGFloat textA = [[textRGBADict objectForKey:@"4_Alpha"] floatValue];
    
    greetingText.textColor = [UIColor colorWithRed:textR / 255.0
                                             green:textG / 255.0
                                              blue:textB / 255.0
                                             alpha:textA];
    
    // setup observer to change position of textView to keep it centered vertically
    [greetingText addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

    //position greetingText View
    CGRect greetingTextFrame = greetingText.frame;
    
    greetingTextFrame.origin.x = [[artCardDict objectForKey:@"textviewX"] integerValue];
    
    //greetingTextFrame.size.width = greetingTextFrame.size.width * ([[artCardDict objectForKey:@"textviewWidth%"] floatValue] / 100);
    greetingTextFrame.size.width = [[artCardDict objectForKey:@"textviewWidth"] integerValue];
    
    greetingTextFrame.size.height = kGreetingTextViewHeight;
    
    // set origin.y last
    greetingTextFrame.origin.y = [[artCardDict objectForKey:@"textviewYCenter"] floatValue] - (greetingTextFrame.size.height / 2);

    [greetingText setFrame:greetingTextFrame];
    
    if ( ![[artCardDict objectForKey:@"isCustomizable"] boolValue]) {
        clearButton.enabled = NO;
        fontButton.enabled = NO;
        greetingText.text = @"";
        greetingText.userInteractionEnabled = NO;
    } else {
        // this line goes after above addObserver, so it gets notified
        greetingText.text = @"Pinch, Zoom, or Drag to edit text.";
    }
    
	[[AppManager sharedAppManager] setCustomizeView:self];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    greetingText.text = greetingText.text;  // so observeValueForKeyPath gets triggered
    [self showToolbarAndText];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    UITextView *tv = object;
    //Center vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


-(UIImage *)getScreenShot {
    [self hideToolbarAndMaybeText];
    
    CGSize quoteSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(quoteSize, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, quoteSize.width, quoteSize.height);

    UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, NO, 0.0f);
    
    CGContextTranslateCTM(ctx, 0.0f, scrollView.frame.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextDrawImage(ctx, area, screenShot.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return (newImage);
}

- (void) hideToolbarAndMaybeText {
    toolBar.hidden = YES;
    if ( ([[artCardDict objectForKey:@"isCustomizable"] boolValue]) && (isChangedGreetingText == NO) )   {
        greetingText.hidden = YES; // so 'Touch here ...' message is not saved with image
    }
}

- (void) showToolbarAndText {
    toolBar.hidden = NO;
    greetingText.hidden = NO;
}

- (void)emailCard {
    if ([MFMailComposeViewController canSendMail]){
        [self.actionPopoverController dismissPopoverAnimated:NO];
        self.actionPopoverController = nil;

        // Create and show composer
        
        //Create a string with HTML formatting for the email body
        NSMutableString *emailBody = [[[NSMutableString alloc] initWithString:@"<html><body>\n"] retain];
	
        //use extra html tags to force multipart/alternative with text/html (otherwise falls back to multipart/mixed with text/plain)
        [emailBody appendString:@"<b></b>\n"];
	   
        UIImage *screenShot = [self getScreenShot];
    
        //Convert the image into data
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(screenShot, 1.0)];
	
        //close the HTML formatting
        [emailBody appendString:@"</body></html>"];

        //Create the mail composer window
        MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
        emailDialog.mailComposeDelegate = self;
        
        [emailDialog setSubject:@"Just for you!"];
        [emailDialog addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"artcard.jpg"];
        [emailDialog setMessageBody:emailBody isHTML:YES];

        [self presentModalViewController:emailDialog animated:YES];
    
        imageData = NULL;
        [imageData release];
	
        [emailBody release];
        [emailDialog release];
    } else{
        [self showToolbarAndText];
        
        // Show some error message here
        [[[[UIAlertView alloc] initWithTitle:@"Mail Info"
                                     message:@"Please setup your mail to use this feature."
                                    delegate:self 
                           cancelButtonTitle:@"OK" 
                           otherButtonTitles:nil] autorelease] show];	
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self showToolbarAndText];
	[[AppManager sharedAppManager] setMailView:controller];
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			// clicked cancel
			break;
		case MFMailComposeResultSaved:
			// saved to draft
			[[[[UIAlertView alloc] initWithTitle:@"Mail Info"
										 message:@"Mail saved to draft"
										delegate:self 
							   cancelButtonTitle:@"OK" 
							   otherButtonTitles:nil] autorelease] show];			
			break;
		case MFMailComposeResultSent:
			// mail sent successfully
			break;
		case MFMailComposeResultFailed:
			// mail failed
			[[[[UIAlertView alloc] initWithTitle:@"Mail Info"
										 message:@"Mail failed"
										delegate:self 
							   cancelButtonTitle:@"OK" 
							   otherButtonTitles:nil] autorelease] show];
			break;
		default:
			// mail was not sent
			[[[[UIAlertView alloc] initWithTitle:@"Mail Info"
										 message:@"Mail not sent"
										delegate:self 
							   cancelButtonTitle:@"OK" 
							   otherButtonTitles:nil] autorelease] show];			
			break;
	}
    
	[[AppManager sharedAppManager] closeModalViewsAFterMail];
}

- (void)tweetCard {
    [self.actionPopoverController dismissPopoverAnimated:NO];
    self.actionPopoverController = nil;
    
    UIImage *screenShot = [self getScreenShot];
    [self showToolbarAndText];
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:@"My Custom Greeting!"];
    [twitter addImage:screenShot];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        if(result == TWTweetComposeViewControllerResultDone)
        {            
            IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
            display.type = NotificationDisplayTypeText;
            [display setNotificationText:@"Tweet posted"];
            [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:2.5];
            [display release];

        } else if(result == TWTweetComposeViewControllerResultCancelled)
        {
            
            IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
            display.type = NotificationDisplayTypeText;
            [display setNotificationText:@"Tweet NOT posted"];
            [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:2.5];
            [display release];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    };
    
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    [twitter release];
 
}

- (IBAction)backButtonPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clearButtonPressed:(id)sender {
	greetingText.text = @"";
    isChangedGreetingText = YES;
}
                                        
- (IBAction)fontButtonPressed:(id)sender {    
    [greetingText resignFirstResponder];
    
    if (self.fontPopoverController) {
		[self.fontPopoverController dismissPopoverAnimated:YES];
		self.fontPopoverController = nil;
        
	} else {
		FontContentTableViewController *contentViewController = [[FontContentTableViewController alloc] initWithNibName:@"FontContentTableViewController" bundle:nil];
        contentViewController.delegate = self;
                
		self.fontPopoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.fontPopoverController.delegate = self;
		[self.fontPopoverController presentPopoverFromRect:CGRectMake(220, 0, 0, 36)
                                                      inView:self.view
                                    permittedArrowDirections:UIPopoverArrowDirectionUp
                                                    animated:YES];       
        
		[contentViewController release];
	}
}
 
- (void)saveToPhotos {
    [self.actionPopoverController dismissPopoverAnimated:NO];
    self.actionPopoverController = nil;
    
    UIImage *screenShot = [self getScreenShot];
    UIImageWriteToSavedPhotosAlbum(screenShot, self, nil, nil);
    
    [self showToolbarAndText];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to Photos" 
                                                    message:@"From Photos you can later Email, MMS, or Set as Wallpaper"
                                                   delegate:self
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)actionButtonPressed:(id)sender {    
	[greetingText resignFirstResponder];

    if (self.actionPopoverController) {
		[self.actionPopoverController dismissPopoverAnimated:YES];
		self.actionPopoverController = nil;

	} else {
		ActionContentViewController *contentViewController = [[ActionContentViewController alloc] initWithNibName:@"ActionContentViewController" bundle:nil];
        contentViewController.delegate = self;
        
		self.actionPopoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.actionPopoverController.delegate = self;
		[self.actionPopoverController presentPopoverFromRect:CGRectMake(266, 0, 40, 36)
												inView:self.view
							  permittedArrowDirections:UIPopoverArrowDirectionUp
											  animated:YES];
        
		[contentViewController release];
	}

}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController
{
	//Safe to release the popover here
	self.actionPopoverController = nil;
    self.fontPopoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController
{
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}


#pragma mark -
#pragma mark FontPopoverDelegate implementation
- (void) changeFont:(NSString *)toFontName
{
    UIFont *font = [self.greetingText font];
    CGFloat pointSize = [font pointSize];
    
    [self.greetingText setFont:[UIFont fontWithName:toFontName size:pointSize]];
}

- (NSString *) getFontName
{
    return ([[self.greetingText font] fontName]);
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {  
    if(alertView.tag == 3) { // View facebook post ?
        if (buttonIndex == 0) { // Cancel
            [self showToolbarAndText];
        } else if (buttonIndex == 1) { // Yes, view post
            
            WebViewController *vbController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            vbController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vbController.isFacebookHome = YES;
            [self presentModalViewController:vbController animated:YES];
            [vbController release];
        }
    }
}

- (void)MMSogram {
    [self.actionPopoverController dismissPopoverAnimated:NO];
    self.actionPopoverController = nil;
        
    UIImage *screenShot = [self getScreenShot];
    imagePasteboard.image = screenShot;
		
    [self showToolbarAndText];
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
}


/* **********  Facebook methods ********** */

- (void) facebookPostToMe {
    //NSLog(@"%s ", __PRETTY_FUNCTION__);
    [self.actionPopoverController dismissPopoverAnimated:NO];
    self.actionPopoverController = nil;
    
    UIImage *screenShot = [self getScreenShot];
    
	//we will release this object when it is finished posting
    FBFeedPost *post = [[FBFeedPost alloc] initWithPhotoMe:screenShot name:@"Just for you!"];
	[post publishPostWithDelegate:self];
    
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Posting ArtCard"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];
}


- (void) facebookGetFriends {    
    [self.actionPopoverController dismissPopoverAnimated:NO];
    self.actionPopoverController = nil;
    
	//we will release this object when it is finished getting
    FBFeedGet *get = [[FBFeedGet alloc] initForFriends];
	[get requestGetWithDelegate:self];
    
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Getting Friends"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];
}

- (void) facebookPostToFriend:(NSString*) _friendId {
    greetingText.text = greetingText.text;  // so observeValueForKeyPath gets triggered

    UIImage *screenShot = [self getScreenShot];
    
	//we will release this object when it is finished posting
    FBFeedPost *post = [[FBFeedPost alloc] initWithPhotoFriend:screenShot friendId:_friendId name:@"Just for you!"];
    
    [post publishPostWithDelegate:self];
    
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Posting ArtCard"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];
}


#pragma mark -
#pragma mark FBFeedPostDelegate

- (void) failedToPublishPost:(FBFeedPost*) _post {
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:2.5];
	[display release];
	
	//release the alloc'd post
	[_post release];
    
    [self showToolbarAndText];
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
    
    //release the alloc'd post
	[_post release];
    
    // successfully posted to Facebook, so make sure from now on the facebook view will always show the user's facebook page
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everPostedToFacebook"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished Posting !" 
                                                    message:@"Go to Facebook to view your ArtCard?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"View", nil];
    alert.tag = 3;
    [alert show];
    [alert release];
}

// if facebook login cancelled
- (void) failedToLoginToFacebook {    
    UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Login Cancel"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:2.5];
	[display release];
    
    [self showToolbarAndText];
}


#pragma mark -
#pragma mark FBFeedGetDelegate

- (void) failedToRequestGet:(FBFeedGet*) _get {
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Get"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:2.5];
	[display release];
	
	//release the alloc'd get
	[_get release];
    
    [self showToolbarAndText];
}

// facebook friends
- (void) finishedRequestingGet:(FBFeedPost*) _get withResult:(id)result{
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
    
    //release the alloc'd get
	[_get release];
    
    // successfully posted to Facebook, so make sure from now on the facebook view will always show the user's facebook page
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everPostedToFacebook"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *friends = [result objectForKey:@"data"]; // array of NSDictionary objects
    
    // if no friends then show alert

	FBFriendsViewController *friendsViewController = [[FBFriendsViewController alloc] initWithNibName:@"FBFriendsViewController" bundle:nil];
    [friendsViewController setAllFriends:friends];  // pass friends to view controller containing table
    [friendsViewController setDelegate:self];
    
	friendsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:friendsViewController animated:YES];
	[friendsViewController release];
    
    // do NOT release allFriends
}

// ******************************************************




- (IBAction)closeKeyboardPressed:(id)sender {
    [greetingText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

/* Methods triggered by keyboard notification events */

-(void)keyboardDidShow:(NSNotification *)aNotification {   
    isInGreetingText = YES;
    
    if ([greetingText isFirstResponder]) {
        if (isChangedGreetingText == NO) {
            greetingText.text = @"";
            isChangedGreetingText = YES;
        }
    
        CGRect viewFrame = scrollView.frame;

        float scrollBy = [[artCardDict objectForKey:@"textviewYCenter"] floatValue] - kCenterOfInputY;
        if (scrollBy > 0) {
            viewFrame.origin.y -= scrollBy;
        }
    
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationBeginsFromCurrentState:YES];
        [UIScrollView setAnimationDuration:0.3];
        [scrollView setFrame:viewFrame];
        [UIScrollView commitAnimations];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification {
    isInGreetingText = NO;
    
    if ([greetingText isFirstResponder]) {
        CGRect viewFrame = scrollView.frame;
    
        float scrollBy = [[artCardDict objectForKey:@"textviewYCenter"] floatValue] - kCenterOfInputY;
        if (scrollBy > 0) {
            viewFrame.origin.y += scrollBy;
        }
    
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationBeginsFromCurrentState:YES];
        [UIScrollView setAnimationDuration:0.3];
        [scrollView setFrame:viewFrame];
        [UIScrollView commitAnimations];
    }
}


/* Text View delegate method */
- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString*)aText {
	NSString* newText = [aTextView.text stringByReplacingCharactersInRange:aRange withString:aText];
	
    CGSize tallerSize = CGSizeMake(aTextView.frame.size.width-15,aTextView.frame.size.height*2); // pretend there's more vertical space to get that extra line to check on
    
	CGSize newSize = [newText sizeWithFont:aTextView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
	        
    int numOfLinesEntered = newSize.height / greetingText.font.lineHeight;
            
    if ( numOfLinesEntered > [[artCardDict objectForKey:@"textLines"] integerValue])  {
        return NO;
    }
    
    if ( (numOfLinesEntered == [[artCardDict objectForKey:@"textLines"] integerValue]) && ([aText isEqualToString:@"\n"]) ) {
        return NO;
    }
    return YES;
}



#pragma mark Handling pinches

- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {    
    if (!isInGreetingText) {
        UIFont *font = [self.greetingText font];
        CGFloat pointSize = [font pointSize];
        NSString *fontName = [font fontName];
    
        pointSize = ((pinch.velocity > 0) ? .4 : -.4) * 1 + pointSize;
    
        if (pointSize < 13) pointSize = 13;
        if (pointSize > 70) pointSize = 70;
        
        [self.greetingText setFont:[UIFont fontWithName:fontName size:pointSize]];
    }
}

- (void)textviewDragged:(UIPanGestureRecognizer *)drag {
    if (!isInGreetingText) {
        UITextView *textView = (UITextView *)drag.view;
        CGPoint translation = [drag translationInView:textView];
    
        // move textview
        textView.center = CGPointMake(textView.center.x + translation.x, textView.center.y + translation.y);
    
        // reset translation
        [drag setTranslation:CGPointZero inView:textView];
    }
}

// Uncomment this code to allow users to rotate text

/*
-(void)textviewRotate:(id)sender {
    if (!isInGreetingText) {
        [self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
    
        if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
            lastRotation = 0.0;
            return;
        }
    
        CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
        CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
        [[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
    
        lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    }
}
*/


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	self.greetingImage = nil;
	self.greetingText = nil;
	self.clearButton = nil;
    self.fontButton = nil;
    self.toolBar = nil;
}

- (void)dealloc {
	[greetingText release];
	[clearButton release];
    [fontButton release];
    [toolBar release];
    
    [super dealloc];
}

@end
