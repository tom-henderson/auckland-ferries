//
//  THXTimeTableViewController.h
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THXFerryStatusDisplay.h"

@interface THXTimeTableViewController : UITableViewController

@property NSString *selectedRoute;
@property IBOutlet THXFerryStatusDisplay *statusDisplay;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
