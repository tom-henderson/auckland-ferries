//
//  THXFerryStatusDisplay.h
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THXFerryStatusDisplay : UIView

@property IBOutlet UILabel *routeLabel;
@property IBOutlet UILabel *destinationLabel;
@property IBOutlet UILabel *departTimeLabel;
@property IBOutlet UILabel *arriveTimeLabel;

@end
