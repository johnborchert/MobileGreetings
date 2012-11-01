//
//
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.

#import "FBFriendsViewController.h"
#import "CustomizeArtCardView.h"
#import "UIImageView+WebCache.h"

@interface FBFriendsViewController ()
// private methods
- (void) reloadForSearchTerm:(NSString *) searchTerm;
@end

@implementation FBFriendsViewController

@synthesize tableView;
@synthesize searchBar;

@synthesize allFriends;
@synthesize sectionTitles;
@synthesize sectionStartRows;
@synthesize friendsMatchingSearch;
@synthesize delegate;
@synthesize postToFriendId;

- (IBAction)buttonPressedBack:(id)sender {
    [self viewDidUnload];
    [self dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad { 
    
    // first sort the raw facebook list by name
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [allFriends sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    sectionTitles         = [[NSMutableArray alloc] init];
    sectionStartRows      = [[NSMutableArray alloc] init];
    friendsMatchingSearch = [[NSMutableArray alloc] init];
    
    self.postToFriendId        = [[NSString alloc] init];

    [self reloadForSearchTerm:@""]; // initially build the search list with all friends
    [super viewDidLoad];
}

- (void) reloadForSearchTerm:(NSString *) searchTerm {
    
    // clear search arrays
    [sectionTitles removeAllObjects];
    [sectionStartRows removeAllObjects];
    [friendsMatchingSearch removeAllObjects];
    
    NSString *previousLetter = @"";
    
    for (int currentFriendCount=0; currentFriendCount<[allFriends count]; currentFriendCount++){
        NSDictionary *friendDictionary = [allFriends objectAtIndex:currentFriendCount];
        NSString *name = [friendDictionary objectForKey:@"name"];
        
        NSString *myRegex = [NSString stringWithFormat:@"\\b%@", searchTerm];
        
        NSRange myRange = [name rangeOfString:myRegex options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
        if (myRange.location != NSNotFound) { // search string matches name
            [friendsMatchingSearch addObject:[NSNumber numberWithInteger:currentFriendCount]]; // store index row of match in allFriends
            
            char charFirstLetter = [name characterAtIndex:0];
            NSString *strFirstLetter = [[NSString stringWithFormat:@"%C", charFirstLetter] capitalizedString];
            
            // if new section, then add row ids for current section to search list
            if ( ![strFirstLetter isEqualToString:previousLetter]) {
                [sectionTitles addObject:strFirstLetter]; // store 1st letter in titles list
                [sectionStartRows addObject:[NSNumber numberWithInteger:([friendsMatchingSearch count]-1)]];  // store index row of friendsMatching
                
                previousLetter = strFirstLetter;
            }
        } else {

        }
    }
    
    [tableView reloadData];
}


#pragma mark Table view methods

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, aTableView.bounds.size.width, 25)] autorelease];

    [headerView setBackgroundColor:[UIColor blackColor]];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, aTableView.bounds.size.width - 10, 18)] autorelease];
    label.text = [sectionTitles objectAtIndex:section];
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.90];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    return [sectionTitles indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int sectionStartRow = [[sectionStartRows objectAtIndex:section] integerValue];
    int nextSectionStartRow;
    
    // find start of next section, if no next section, then grab the length of whole friendsMatchingSearch array
    if (section < ([sectionStartRows count]-1)) {
        nextSectionStartRow = [[sectionStartRows objectAtIndex:(section+1)] integerValue];
    } else {
        nextSectionStartRow = [friendsMatchingSearch count];
    }

    return (nextSectionStartRow - sectionStartRow);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInTable:(NSInteger)section {
    return [friendsMatchingSearch count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    int sectionStartRow = [[sectionStartRows objectAtIndex:section] integerValue];
    int rowInSearch     = sectionStartRow + row;
    
    int rowWithData = [[friendsMatchingSearch objectAtIndex:rowInSearch] integerValue];
    NSDictionary *friendDictionary = [allFriends objectAtIndex:rowWithData];
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [inTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier] autorelease];
    }
    
    NSString *friendId = [friendDictionary objectForKey:@"id"];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", friendId]]
                   placeholderImage:[UIImage imageNamed:@"FBFriendsPlaceholder.gif"]];
    
    cell.textLabel.text = [friendDictionary objectForKey:@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

	// now return this cell
	return cell;
}

// Method for Selecting TableCell
- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    int sectionStartRow = [[sectionStartRows objectAtIndex:[indexPath section]] integerValue];
    int row = sectionStartRow + [indexPath row];
    
    int rowWithData = [[friendsMatchingSearch objectAtIndex:row] integerValue];
    NSDictionary *friendDictionary = [allFriends objectAtIndex:rowWithData];
    
    self.postToFriendId = [friendDictionary objectForKey:@"id"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:[NSString stringWithFormat:@"Post to %@'s Wall?", [friendDictionary objectForKey:@"first_name"]]
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Post", nil];
    [alert show];
    [alert release];
} 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Cancel

    } else if (buttonIndex == 1) { // Post
        [self.delegate facebookPostToFriend: self.postToFriendId];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [searchBar resignFirstResponder];
    return indexPath;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {	
	aSearchBar.text = nil;	
	[aSearchBar resignFirstResponder];
	
	[self reloadForSearchTerm:@""];
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
    [self reloadForSearchTerm:searchText];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)aSearchBar {  
    [aSearchBar setShowsCancelButton:YES animated:YES];
    return YES;
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)aSearchBar {  
    [aSearchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
	
- (void)viewDidUnload {
	[super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
    self.tableView = nil;
    self.searchBar = nil;
    self.allFriends = nil;
    self.sectionTitles = nil;
    self.sectionStartRows = nil;
    self.friendsMatchingSearch = nil;
    self.postToFriendId = nil;
}
	
- (void)dealloc {
    [tableView release];
    [searchBar release];
    [allFriends release];
    [sectionTitles release];
    [sectionStartRows release];
    [friendsMatchingSearch release];

	[super dealloc];
}
	
@end
