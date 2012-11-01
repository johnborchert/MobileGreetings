//
//
//  Created by Elizabeth Boylan on 11-02-20.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBFeedPost.h"
#import "FBFeedGet.h"
#import "IFNNotificationDisplay.h"
#import "WEPopoverController.h"
#import "ActionContentViewController.h"
#import "FontContentTableViewController.h"

#define kGreetingTextViewHeight 500
#define kCenterOfInputY 155  

@interface CustomizeArtCardView : UIViewController <MFMailComposeViewControllerDelegate, UITextViewDelegate, FBFeedPostDelegate, WEPopoverControllerDelegate, ActionPopoverDelegate, FontPopoverDelegate> {
    NSDictionary *artCardDict;
    
	UIImageView *greetingImage;
	UITextView *greetingText;
	UIBarButtonItem *clearButton;	
    UIBarButtonItem *fontButton;
    UIToolbar *toolBar;
	BOOL isChangedGreetingText;
	UIPasteboard *imagePasteboard;
    
    IBOutlet UIScrollView *scrollView;
    
    CGFloat lastRotation;
    
    BOOL isInGreetingText;
    
    UIBarButtonItem *actionButton;	
    WEPopoverController *actionPopoverController;
    WEPopoverController *fontPopoverController;
}

@property (nonatomic, retain) NSDictionary *artCardDict;

@property (nonatomic, retain) IBOutlet UIImageView *greetingImage;
@property (nonatomic, retain) IBOutlet UITextView *greetingText;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *clearButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fontButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@property (nonatomic) BOOL isChangedGreetingText;
@property (nonatomic) BOOL isInGreetingText;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic, retain) WEPopoverController *actionPopoverController;
@property (nonatomic, retain) WEPopoverController *fontPopoverController;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)fontButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)closeKeyboardPressed:(id)sender;

- (void) facebookPostToFriend:(NSString*) _friendId;

@end
