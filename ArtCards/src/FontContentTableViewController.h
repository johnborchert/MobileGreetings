//
//  FontContentTableViewController.h
//
//  Created by John Borchert on 11-07-17.
//  Copyright 2011 VectorBloom!. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontPopoverDelegate;

@interface FontContentTableViewController : UITableViewController {
    id <FontPopoverDelegate> delegate;
    NSArray *fontsArray;
    NSUInteger lastIndexPathRow;
}

@property (nonatomic, assign) id <FontPopoverDelegate> delegate;
@property (nonatomic, retain) NSArray *fontsArray;
@property (nonatomic, assign) NSUInteger lastIndexPathRow;

@end

@protocol FontPopoverDelegate <NSObject>
@required
- (void) changeFont:(NSString *)toFontName;
- (NSString *) getFontName;
@end
