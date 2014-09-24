//
//  THXAppDelegate.m
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import "THXAppDelegate.h"

#define kFerryTerminalStopIDs 
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kRoutesDataURL [NSURL URLWithString:@"http://api.at.govt.nz/v1/gtfs/routes?api_key=20dd655d-2fc6-4930-9992-a8682392ad35"]

@implementation THXAppDelegate

#pragma Data Fetching Methods
-(void)loadData
{
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kRoutesDataURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    if (error) NSLog(@"%@", error);

    NSArray *routes = [json objectForKey:@"response"];

    NSLog(@"%@", routes);
}

#pragma Application Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.routes = @[@"6675", @"5235", @"5241", @"5233", @"5237", @"5240", @"5238", @"5255", @"5234", @"6108", @"6456", @"5236", @"5239", @"5252"];
    self.routeNames = @{
                        @"6675": @"Auckland City",
                        @"5235": @"Bayswater",
                        @"5241": @"Beach Haven",
                        @"5233": @"Birkenhead",
                        @"5237": @"Devonport",
                        @"5240": @"Gulf Harbour",
                        @"5238": @"Half Moon Bay",
                        @"5255": @"Hobsonville",
                        @"5234": @"Northcote Point",
                        @"6108": @"Pine Harbour",
                        @"6456": @"Rakino Island",
                        @"5236": @"Stanley Point",
                        @"5239": @"Waiheke Island",
                        @"5252": @"West Harbour",
                        };

    //[self loadData];
    self.selectedDepartureTerminal = @"5235";
    self.selectedDestinationTerminal = @"6675";
    self.travelDirection = THXTravelDirectionOutbound;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
