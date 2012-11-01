//
//
//  Created by John Borchert on 11-06-16.
//  Copyright 2011 VectorBloom Technologies. All rights reserved.
//

#import "ActionContentViewController.h"

@implementation ActionContentViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)buttonPressedSave:(id)sender {
    if ([self.delegate respondsToSelector:@selector(saveToPhotos)])
        [self.delegate saveToPhotos];
}

-(IBAction)buttonPressedMMS:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MMSogram)])
        [self.delegate MMSogram];
}

-(IBAction)buttonPressedEmail:(id)sender {
    if ([self.delegate respondsToSelector:@selector(emailCard)])
        [self.delegate emailCard];
}

-(IBAction)buttonPressedFacebookMe:(id)sender {
    if ([self.delegate respondsToSelector:@selector(facebookPostToMe)])
        [self.delegate facebookPostToMe];
}

-(IBAction)buttonPressedFacebookFriends:(id)sender {
    if ([self.delegate respondsToSelector:@selector(facebookGetFriends)])
        [self.delegate facebookGetFriends];
}

-(IBAction)buttonPressedTwitter:(id)sender {    
    if ([self.delegate respondsToSelector:@selector(tweetCard)])
        [self.delegate tweetCard];
}

@end
