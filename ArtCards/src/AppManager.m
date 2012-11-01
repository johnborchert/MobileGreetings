//
//  AppManager.m
//
//  Created by John Borchert on 11-01-21.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//
// 

#import "AppManager.h"

static AppManager *_sharedManager = nil;

@interface AppManager ()
// private methods
- (void) determineDevice;
@end

@implementation AppManager

@synthesize isHighResScreen;
@synthesize isiPad;

@synthesize customizeView;  // value updated in CustomizeArtCardView.m
@synthesize mailView;       // value updated in CustomizeArtCardView.m


- (id)init {
	if ((self=[super init])) {
		//figure out what device is being used
		[self determineDevice];
		if (self.isiPad) {
		} else { // iphone & ipod
		}
    }
    return self;
}


- (void) determineDevice {
	// Determine if low or high resolution screen
	self.isHighResScreen = NO;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		CGFloat scale = [[UIScreen mainScreen] scale];
		if (scale > 1.0) {
			self.isHighResScreen = YES;
		}
	}
		
	self.isiPad = NO;
	if([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
		self.isiPad = YES;
	}
	
}

- (void)closeModalViewsAFterMail {
    [self.mailView dismissModalViewControllerAnimated:NO];
}




/* Singleton methods below -- do not change */

+ (id)sharedAppManager {
	//NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
    @synchronized(self) {
        if(_sharedManager == nil)
            _sharedManager = [[super allocWithZone:NULL] init];
    }
    return _sharedManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedAppManager] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; // denotes an object that cannot be released
}

//- (void)release {
    // never release
//}

- (id)autorelease {
    return self;
}
- (void)dealloc {
    // Should never be called
    [super dealloc];
}

@end