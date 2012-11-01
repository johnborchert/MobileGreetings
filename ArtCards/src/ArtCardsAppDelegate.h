//
//
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainArtViewController;

@interface ArtCardsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainArtViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainArtViewController *viewController;

@end
