//
//
//  Created by Elizabeth Boylan on 10-12-16.
//  Copyright 2010 VectorBloom Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	UITableView *tableView;
    UISearchBar *searchBar;
    
    NSMutableArray *allFriends;                 // ordered list of friends
    NSMutableArray *sectionTitles;              // holds array of titles 'A', 'C', 'D', etc.
    NSMutableArray *sectionStartRows;           // list of rowIds (of friendsMatchingSearch) where section starts
    NSMutableArray *friendsMatchingSearch;      // list of rowIds (of allFriends) matching search
    id delegate;
    NSString *postToFriendId;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *allFriends;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sectionStartRows;
@property (nonatomic, retain) NSMutableArray *friendsMatchingSearch;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *postToFriendId;

- (IBAction)buttonPressedBack:(id)sender;

@end
