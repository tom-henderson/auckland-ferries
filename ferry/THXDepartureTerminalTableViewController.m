//
//  THXRoutesTableViewController.m
//  ferry
//
//  Created by Tom Henderson on 19/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import "THXDepartureTerminalTableViewController.h"
#import "THXAppDelegate.h"
#import "THXTimeTableViewController.h"
#import "THXTableViewCellWithSwipeMenu.h"

@interface THXDepartureTerminalTableViewController ()

@property NSMutableArray *routes;

@end

@implementation THXDepartureTerminalTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setCheckmarkForRowAtIndexPath:(NSIndexPath *)indexPath
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
}

- (void)viewWillAppear:(BOOL)animated
{
    // Workaround #1 for jumpy navbar
    [self.navigationController.navigationBar.layer removeAllAnimations];

    THXAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[app.routes indexOfObject:app.selectedDepartureTerminal]
                                                 inSection:0];
    [self setCheckmarkForRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    THXAppDelegate *app = [[UIApplication sharedApplication] delegate];
    return app.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeCell" forIndexPath:indexPath];

    THXAppDelegate *app = [[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [app.stopNames objectForKey:[app.routes objectAtIndex:indexPath.row]];

    if (app.selectedDepartureTerminal == [app.routes objectAtIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self setCheckmarkForRowAtIndexPath:indexPath];

    THXAppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.selectedDepartureTerminal = [app.routes objectAtIndex:indexPath.row];

    if ([[app.possibleDestinations objectForKey:app.selectedDepartureTerminal] count] == 1) {
        [self performSegueWithIdentifier:@"unwindToTimeTable" sender:self];
    }
}

#pragma UIScrollViewDelegate Methods

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:THXTableViewCellsShouldHideMenu object:scrollView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Workaround #2 for jumpy navbar
    THXTimeTableViewController *dest = segue.destinationViewController;
    [dest.navigationController.navigationBar.layer removeAllAnimations];
}


@end
