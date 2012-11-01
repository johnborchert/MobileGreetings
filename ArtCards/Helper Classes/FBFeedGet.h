//
//  FBFeedPost.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRequestWrapper.h"

@protocol FBFeedGetDelegate;

typedef enum {
    FBGetTypeFriends = 0, // new code added by VectorBloom May 4, 2011
    FBGetTypeFriendPicture = 1 // new code added by VectorBloom - May 4, 2011
} FBGetType;

@interface FBFeedGet : NSObject <FBRequestDelegate, FBSessionDelegate>
{
    FBGetType getType;
	
	id <FBFeedGetDelegate> delegate;
}

@property (nonatomic, assign) FBGetType getType;

@property (nonatomic, assign) id <FBFeedGetDelegate> delegate;

- (id) initForFriends;
- (id) initForFriendPicture;

- (void) requestGetWithDelegate:(id) _delegate;

@end


@protocol FBFeedGetDelegate <NSObject>
@required
- (void) failedToRequestGet:(FBFeedGet*) _get;
- (void) finishedRequestingGet:(FBFeedGet*) _get withResult:(id)result;

- (void) failedToLoginToFacebook;
@end