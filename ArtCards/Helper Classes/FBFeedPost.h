//
//  FBFeedPost.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRequestWrapper.h"

@protocol FBFeedPostDelegate;

typedef enum {
  FBPostTypeStatus = 0,
  FBPostTypePhotoMe = 1,
  FBPostTypePhotoFriend = 2, // new code added by VectorBloom May 2, 2011
  FBPostTypeLink = 3,
  FBPostTypePhotoLink = 4 // new code added by VectorBloom April 28, 2011
} FBPostType;

@interface FBFeedPost : NSObject <FBRequestDelegate, FBSessionDelegate>
{
	NSString *url;
	NSString *message;
	NSString *caption;
	UIImage *image;
	FBPostType postType;
    NSString *friendId;
	
	id <FBFeedPostDelegate> delegate;
}

@property (nonatomic, assign) FBPostType postType;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *friendId;

@property (nonatomic, assign) id <FBFeedPostDelegate> delegate;

- (id) initWithLinkPath:(NSString*) _url caption:(NSString*) _caption;
- (id) initWithPostMessage:(NSString*) _message;
- (id) initWithPhotoMe:(UIImage*) _image name:(NSString*) _name;
- (id) initWithPhotoFriend:(UIImage*) _image friendId:(NSString*) _friendId name:(NSString*) _name;
- (id) initWithPhotoLinkPath:(NSString*) _url message:(NSString*) _message; // new code added by VectorBloom April 28, 2011

- (void) publishPostWithDelegate:(id) _delegate;

@end


@protocol FBFeedPostDelegate <NSObject>
@required
- (void) failedToPublishPost:(FBFeedPost*) _post;
- (void) finishedPublishingPost:(FBFeedPost*) _post;

- (void) failedToLoginToFacebook;
@end