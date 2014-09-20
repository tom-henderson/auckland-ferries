//
//  THXRoutesTableViewController.m
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import "THXRoutesTableViewController.h"
#import "THXTimeTableViewController.h"

@interface THXRoutesTableViewController ()

@property NSMutableArray *routes;

@end

@implementation THXRoutesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    for (int row = 0; row < [self.tableView numberOfRowsInSection:indexPath.section]; row++) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.routes = [NSMutableArray arrayWithArray:@[@"Birkenhead", @"Northcote Point", @"Bayswater", @"Stanley Point",
                                                   @"Devonport", @"Half Moon Bay", @"Waiheke", @"Gulf Harbour", @"Beach Haven",
                                                   @"West Harbour", @"Hobsonville", @"Pine Harbour", @"Rakino"]];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.routes indexOfObject:self.selectedRoute] inSection:0];
    [self selectCellAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Workaround #1 for jumpy navbar
    [self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.routes objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectCellAtIndexPath:indexPath];
    self.selectedRoute = [self.routes objectAtIndex:indexPath.row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    THXTimeTableViewController *dest = segue.destinationViewController;
    dest.selectedRoute = self.selectedRoute;

    // Workaround #2 for jumpy navbar
    /*
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:nil
                    completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
     */
    [dest.navigationController.navigationBar.layer removeAllAnimations];
}


@end
