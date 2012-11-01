//
//  
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.



#import "MainArtViewController.h"
#import "CustomizeArtCardView.h"
#import "BioViewController.h"
#import "WebViewController.h"

// used by iCarousel
#define ITEM_SPACING 240
#define kScroll_Zone_Start_X .15

@interface MainArtViewController ()
// private methods
@end

@implementation MainArtViewController
@synthesize carousel;
@synthesize artCardArray;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *pathSalon = [[NSBundle mainBundle] pathForResource:@"ArtCards" ofType:@"plist"];
    artCardArray = [[NSArray alloc] initWithContentsOfFile:pathSalon];
    
    carousel.type = iCarouselTypeCoverFlow;
    [carousel reloadData];  // needed to add this line when upgrading from v1.5.1 to v1.5.6

    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:.5];
}

- (void)viewWillAppear:(BOOL)animated {
    [UIAccelerometer sharedAccelerometer].delegate = self;  // turn on accelerometer
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIAccelerometer sharedAccelerometer].delegate = nil;  // turn off accelerometer
}

-(void)buttonPressedBio:(id)sender {
	BioViewController *controller = [[BioViewController alloc] initWithNibName:@"BioViewController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

-(void)buttonPressedVectorbloom:(id)sender {
	WebViewController *controller = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}
 
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.    
    self.carousel = nil;
    self.artCardArray = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [carousel release];
    [artCardArray release];
    
	[super dealloc];	
}






#pragma mark -
#pragma mark iCarouselDataSource methods

// required
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.artCardArray count];
}

// required
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // get the dictionary for this item out of the art card data array
    NSDictionary *artCardDict = [artCardArray objectAtIndex:index];
    
    UIImage *image;
    if ( [allTrim([artCardDict objectForKey:@"imageCarousel"]) length] != 0 )
    {
        image = [UIImage imageNamed:[artCardDict objectForKey:@"imageCarousel"]];
    } else
    {
        image = [UIImage imageNamed:[artCardDict objectForKey:@"imageFull"]];
    }
    
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 221, 331)] autorelease];

    [button setBackgroundImage:image forState:UIControlStateNormal];

    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;

    return button;
}


#pragma mark -
#pragma mark iCarouselDelegate methods

- (float)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(float)offset
{
    //set opacity based on distance from camera
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    //do 3d transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return YES;
}


#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    //[UIAccelerometer sharedAccelerometer].delegate = nil;  // uncomment this line to turn of accelerometer
    
    int numArtCard = sender.tag;
    
    CustomizeArtCardView *controller = [[CustomizeArtCardView alloc] initWithNibName:@"CustomizeArtCardView" bundle:nil];
    
    // get the dictionary for this item out of the art card data array
    NSDictionary *artCardDict;
    artCardDict = [artCardArray objectAtIndex:numArtCard];
    
    controller.artCardDict = artCardDict;
    [artCardDict release];

    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   
    [self presentModalViewController:controller animated:YES];
    [controller release];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
*/


- (void) accelerometer: (UIAccelerometer *)accelerometer didAccelerate: (UIAcceleration *)acceleration {   

    if ( fabs(acceleration.x) > kScroll_Zone_Start_X)
    {
        float perc = .85 * (1 - fabs(acceleration.x));  // half way is around .58
        float duration = .5 * perc;
        
        float updateInterval;
        if (duration > .32)
        {
            updateInterval = duration * 1.25;
        } else {
            duration = duration * .4;
            updateInterval = duration + .04;
        }
                
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:updateInterval];

        if (acceleration.x > kScroll_Zone_Start_X)
        {
            [carousel scrollByNumberOfItems:-1 duration:duration];
        } else if (acceleration.x < -kScroll_Zone_Start_X)
        {
            [carousel scrollByNumberOfItems:1 duration:duration];
        }
    }
}

@end

