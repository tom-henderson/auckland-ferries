//
//  THXAppDelegate.h
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSArray *routes;
@property NSDictionary *routeNames;

@property NSString *selectedDepartureTerminal;
@property NSMutableArray *selectedRouteTripTimesOut;
@property NSMutableArray *selectedRouteTripTimesReturn;

@end
