//
//  FBFeedPost.m
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBFeedPost.h"


@implementation FBFeedPost
@synthesize message, caption, image, url, postType, friendId, delegate;

- (id) initWithLinkPath:(NSString*) _url caption:(NSString*) _caption {
	self = [super init];
	if (self) {
		postType = FBPostTypeLink;
		url = [_url retain];
		caption = [_caption retain];
	}
	return self;
}

- (id) initWithPostMessage:(NSString*) _message {
	self = [super init];
	if (self) {
		postType = FBPostTypeStatus;
		message = [_message retain];
	}
	return self;
}

- (id) initWithPhotoMe:(UIImage*) _image name:(NSString*) _name {
	self = [super init];
	if (self) {
		postType = FBPostTypePhotoMe;
		image = [_image retain];
		caption = [_name retain];
	}
	return self;
}

// new code added by VectorBloom May 2, 2011
- (id) initWithPhotoFriend:(UIImage*) _image friendId:(NSString*) _friendId name:(NSString*) _name {
	self = [super init];
	if (self) {
		postType = FBPostTypePhotoFriend;
		image = [_image retain];
		caption = [_name retain];
        friendId = [_friendId retain];
	}
	return self;
}

// new code added by VectorBloom April 28, 2011
- (id) initWithPhotoLinkPath:(NSString*) _url message:(NSString*) _message {
	self = [super init];
	if (self) {
		postType = FBPostTypePhotoLink;
		url = [_url retain];
		message = [_message retain];
	}
	return self;
}

- (void) publishPostWithDelegate:(id) _delegate { 
	//store the delegate incase the user needs to login
	self.delegate = _delegate;
	
	// if the user is not currently logged in begin the session
	BOOL loggedIn = [[FBRequestWrapper defaultManager] isLoggedIn];
	if (!loggedIn) {
		[[FBRequestWrapper defaultManager] FBSessionBegin:self];    
	}
	else {
		NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
        		
		//Need to provide POST parameters to the Facebook SDK for the specific post type
		NSString *graphPath = @"me/feed";
		
		switch (postType) {
			case FBPostTypeLink:
			{
				[params setObject:@"link" forKey:@"type"];
				[params setObject:self.url forKey:@"link"];
				[params setObject:self.caption forKey:@"description"];
				break;
			}
			case FBPostTypeStatus:
			{
				[params setObject:@"status" forKey:@"type"];
				[params setObject:self.message forKey:@"message"];
				break;
			}
			case FBPostTypePhotoMe:
			{
				graphPath = @"me/photos";
                
                [params setObject:self.image forKey:@"source"];
                
                NSString *themessage     = @"";  // needed to blank out the caption
                [params setObject:themessage forKey:@"message"];
                
				break;
            }
			case FBPostTypePhotoFriend:
			{
				graphPath = @"me/photos";
                [params setObject:self.image forKey:@"source"];

                NSString *tags           = [NSString stringWithFormat:@"[{'tag_uid': '%@', 'x': 1, 'y': 1}]", self.friendId];
                [params setObject:tags forKey:@"tags"];
                
                NSString *themessage     = @"";  // needed to blank out the caption
                [params setObject:themessage forKey:@"message"];

				break;
            }
            // code added by VectorBloom April 28, 2011
            case FBPostTypePhotoLink:
            {                 
                break;
            }
			default:
				break;
		}
		
		[[FBRequestWrapper defaultManager] sendFBRequestWithGraphPath:graphPath params:params andDelegate:self];
	}	
}

#pragma mark -
#pragma mark FacebookSessionDelegate

- (void)fbDidLogin {
	[[FBRequestWrapper defaultManager] setIsLoggedIn:YES];
	
	//after the user is logged in try to publish the post
	[self publishPostWithDelegate:self.delegate];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    // JB 2011-04-06 added code to display failed to login message
    if ([self.delegate respondsToSelector:@selector(failedToLoginToFacebook)])
        [self.delegate failedToLoginToFacebook];
    
	[[FBRequestWrapper defaultManager] setIsLoggedIn:NO];
	
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([self.delegate respondsToSelector:@selector(failedToPublishPost:)])
		[self.delegate failedToPublishPost:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([self.delegate respondsToSelector:@selector(finishedPublishingPost:)])
		[self.delegate finishedPublishingPost:self];
}


- (void) dealloc {
	self.delegate = nil;
	[url release], url = nil;
	[message release], message = nil;
	[caption release], caption = nil;
	[image release], image = nil;
    [friendId release], friendId = nil;
	[super dealloc];
}

@end
