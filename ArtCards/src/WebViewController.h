//
//
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFNNotificationDisplay.h"

@interface WebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *myWebView;
    BOOL   isFacebookHome;
}

@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic) BOOL isFacebookHome;

- (IBAction)buttonPressedBack:(id)sender;
- (IBAction)buttonPressedInstructions:(id)sender;
- (IBAction)buttonPressedtwitterAccount:(id)sender;
- (IBAction)buttonPressedfacebookPage:(id)sender;
- (IBAction)buttonPressedvbOnline:(id)sender;

@end
