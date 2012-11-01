//
//  FontContentTableViewController.m
//
//  Created by John Borchert on 11-07-17.
//  Copyright 2011 VectorBloom!. All rights reserved.
//

#import "FontContentTableViewController.h"


@implementation FontContentTableViewController

@synthesize delegate;
@synthesize fontsArray;
@synthesize lastIndexPathRow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [fontsArray release];
    
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
    NSString *tempFontsPath = [[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"];
    NSArray *tempFontsArray = [[NSArray alloc] initWithContentsOfFile:tempFontsPath];
        
    self.fontsArray = tempFontsArray;
    [tempFontsArray release];
 
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.fontsArray = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
    
    // run this code after delegate is set
    
    NSString *currentFontName = @"";
    
    if ([self.delegate respondsToSelector:@selector(getFontName)])
    {
        currentFontName = [self.delegate getFontName];
    }
        
    NSDictionary *infoDict;
    for (int fontNum=0; fontNum<[self.fontsArray count]; ++fontNum)
    { 
        infoDict = [self.fontsArray objectAtIndex:fontNum];
        if ( [[infoDict objectForKey:@"fontName"] isEqualToString:currentFontName] )
        {
            lastIndexPathRow = fontNum;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:fontNum inSection:0];
            [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fontsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSDictionary *infoDict = [self.fontsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [infoDict objectForKey:@"fontNameInPopover"];

    float fontSize = [[infoDict objectForKey:@"fontSizeInPopover"] floatValue];
    cell.textLabel.font = [UIFont fontWithName:[infoDict objectForKey:@"fontName"] size:fontSize];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSUInteger row = [indexPath row];
    cell.accessoryType = (row == lastIndexPathRow) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (row != lastIndexPathRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPathRow inSection:0]];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastIndexPathRow = [indexPath row]; 
    }
    else
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPathRow inSection:0]];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastIndexPathRow = [indexPath row];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *infoDict = [self.fontsArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(changeFont:)])
        [self.delegate changeFont:[infoDict objectForKey:@"fontName"]];
}

@end
