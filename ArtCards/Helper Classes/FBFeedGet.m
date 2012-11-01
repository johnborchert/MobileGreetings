//
//  FBFeedPost.m
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBFeedGet.h"


@implementation FBFeedGet
@synthesize getType, delegate;

// new code added by VectorBloom May 4, 2011 - for friends
- (id) initForFriends {
	self = [super init];
    if (self) {
		getType = FBGetTypeFriends;
	}
	return self;
}

- (id) initForFriendPicture {
	self = [super init];
    if (self) {
		getType = FBGetTypeFriendPicture;
	}
	return self;
}

- (void) requestGetWithDelegate:(id) _delegate {
	//store the delegate incase the user needs to login
	self.delegate = _delegate;
	
	// if the user is not currently logged in begin the session
	BOOL loggedIn = [[FBRequestWrapper defaultManager] isLoggedIn];
	if (!loggedIn) {
		[[FBRequestWrapper defaultManager] FBSessionBegin:self];    
	}
	else {
		//Need to provide POST parameters to the Facebook SDK for the specific post type
		NSString *graphPath;
		
		switch (getType) {
			case FBGetTypeFriends:
			{
                graphPath = @"me/friends?fields=id,name,first_name,last_name";
                
				break;
            }
            case FBGetTypeFriendPicture:
			{
				graphPath = @"999999999999999/picture";
                
				break;
            }
			default:
				break;
		}
		
		[[FBRequestWrapper defaultManager] getFBRequestWithGraphPath:graphPath andDelegate:self];
	}	
}

#pragma mark -
#pragma mark FacebookSessionDelegate

- (void)fbDidLogin {
	[[FBRequestWrapper defaultManager] setIsLoggedIn:YES];
	
	//after the user is logged in try to publish the post
	[self requestGetWithDelegate:self.delegate];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    // new code added by VectorBloom 2011-04-06 to display failed to login message
    if ([self.delegate respondsToSelector:@selector(failedToLoginToFacebook)])
        [self.delegate failedToLoginToFacebook];
    
	[[FBRequestWrapper defaultManager] setIsLoggedIn:NO];
	
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([self.delegate respondsToSelector:@selector(failedToRequestGet:)])
		[self.delegate failedToRequestGet:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([self.delegate respondsToSelector:@selector(finishedRequestingGet:withResult:)])
		[self.delegate finishedRequestingGet:self withResult:result];
}


- (void) dealloc {
	self.delegate = nil;
	[super dealloc];
}

@end
