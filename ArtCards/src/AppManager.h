//
//  AppManager.h
//
//  Created by John Borchert on 11-01-21.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//

@interface AppManager : NSObject {
	BOOL isHighResScreen;
	BOOL isiPad;
    
	UIViewController *customizeView;
	UIViewController *mailView;
}

@property (nonatomic) BOOL isHighResScreen;
@property (nonatomic) BOOL isiPad;

@property (nonatomic, retain) UIViewController *customizeView;
@property (nonatomic, retain) UIViewController *mailView;

- (void)closeModalViewsAFterMail;

+ (id)sharedAppManager;

@end
