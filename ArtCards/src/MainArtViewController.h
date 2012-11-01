//
//  
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MainArtViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UIAccelerometerDelegate> {
    iCarousel *carousel;
    NSArray *artCardArray;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) NSArray *artCardArray;

- (IBAction)buttonPressedBio:(id)sender;
- (IBAction)buttonPressedVectorbloom:(id)sender;

@end
