//
//
//  Created by John Borchert on 11-06-16.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionPopoverDelegate;

@interface ActionContentViewController : UIViewController {
    id <ActionPopoverDelegate> delegate;
}

@property (nonatomic, assign) id <ActionPopoverDelegate> delegate;

- (IBAction)buttonPressedMMS:(id)sender;
- (IBAction)buttonPressedEmail:(id)sender;
- (IBAction)buttonPressedFacebookMe:(id)sender;
- (IBAction)buttonPressedFacebookFriends:(id)sender;
- (IBAction)buttonPressedTwitter:(id)sender;
- (IBAction)buttonPressedSave:(id)sender;

@end

@protocol ActionPopoverDelegate <NSObject>
@required
- (void) saveToPhotos;
- (void) MMSogram;
- (void) emailCard;
- (void) facebookPostToMe;
- (void) facebookGetFriends;
- (void) tweetCard;
@end
