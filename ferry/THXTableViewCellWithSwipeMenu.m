//
//  THXTableViewCellWithSwipeMenu.m
//  ferry
//
//  Created by Tom Henderson on 21/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import "THXTableViewCellWithSwipeMenu.h"

NSString *const THXTableViewCellsShouldHideMenu = @"THXTableViewCellsShouldHideMenu";

#define kButtonWidth 74.0f
#define kDefaultActionThreshold 74.0f // How close to the edge before we transition to the default action?

#pragma mark Interface
@interface THXTableViewCellWithSwipeMenu () <UIScrollViewDelegate>

@property UIScrollView *scrollView;

@property UIView *scrollViewForegroundView;
@property UILabel *cellTextLabel;

@property UIView *scrollViewBackgroundView;
@property NSMutableArray *buttons;

@property BOOL isShowingMenu;
@property BOOL willActivateDefaultAction;

@property int numberOfButtons;

@end

#pragma mark Implementation
@implementation THXTableViewCellWithSwipeMenu

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setup
{
    self.isShowingMenu = NO;
    self.willActivateDefaultAction = NO;

    self.buttons = [[NSMutableArray alloc] init];

    // Create a scrollView and add it to the cell's contentView:
    self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.contentView addSubview:self.scrollView];

    self.scrollViewBackgroundView = [[UIView alloc] init];

    // Create the scrollViewForegroundView:
    self.scrollViewForegroundView = [[UIView alloc] initWithFrame:
                                     CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollViewForegroundView.backgroundColor = [UIColor whiteColor];

    self.cellTextLabel = [[UILabel alloc] initWithFrame:
                            CGRectInset(self.scrollViewForegroundView.bounds, 10.0f, 0.0f)];
    [self.scrollViewForegroundView addSubview:self.cellTextLabel];

    [self.scrollView addSubview:self.scrollViewBackgroundView];
    [self.scrollView addSubview:self.scrollViewForegroundView];

    // Set up some buttons:
    [self addButtonWithTitle:@"Delete"
                  titleColor:[UIColor whiteColor]
             backgroundColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f]];

    [self addButtonWithTitle:@"Flag"
                titleColor:[UIColor whiteColor]
         backgroundColor:[UIColor colorWithRed:0.243 green:0.447 blue:0.651 alpha:1.000]];

    [self addButtonWithTitle:@"More"
                 titleColor:[UIColor whiteColor]
           backgroundColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButtons:) name:THXTableViewCellsShouldHideMenu  object:nil];
}

-(void)addButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.backgroundColor = backgroundColor;
    newButton.frame = CGRectMake( CGRectGetWidth(self.bounds) - (kButtonWidth * (self.buttons.count + 1)), 0.0f, kButtonWidth, CGRectGetHeight(self.bounds));
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setTitleColor:titleColor forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(userPressedButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollViewBackgroundView addSubview:newButton];
    [self.buttons addObject:newButton];

    [self.scrollViewBackgroundView bringSubviewToFront:[self.buttons firstObject]];

    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    float width = CGRectGetWidth(self.bounds);
    float height = CGRectGetHeight(self.bounds);

    //self.scrollView.contentSize = CGSizeMake(width + (kButtonWidth * self.buttons.count), height);
    self.scrollView.contentSize = CGSizeMake(width * 2.0f, height);
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, width, height);
    self.scrollViewBackgroundView.frame = CGRectMake(0.0f, 0.0f, width, height);
    self.scrollViewForegroundView.frame = CGRectMake(0.0f, 0.0f, width, height);
}

-(void)hideButtons:(NSNotification *)notification
{
    // Only if this cell didn't send the notificaiton
    if (notification.object != self) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.isShowingMenu = NO;
    }
}

- (UILabel *)textLabel
{
    return self.cellTextLabel;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

#pragma mark Button Actions

-(void)userPressedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%@", button.titleLabel.text);
}


#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = CGRectGetWidth(self.bounds);
    float height = CGRectGetHeight(self.bounds);
    float offset = scrollView.contentOffset.x;

    // Don't allow scrolling to the right
    if (offset < 0) {
        scrollView.contentOffset = CGPointZero;
    }

    // Fix the position of scrollViewBackgroundView
    self.scrollViewBackgroundView.frame = CGRectMake(offset, 0.0f, width, height);

    // If we scroll far enough, activate the default button
    UIButton *defaultButton = [self.buttons firstObject];
    if ( offset > width - kDefaultActionThreshold) {
        self.willActivateDefaultAction = YES;
        defaultButton.frame = CGRectMake(width - offset, 0.0f, offset, height);
    } else {
        self.willActivateDefaultAction = NO;
        defaultButton.frame = CGRectMake( width - kButtonWidth, 0.0f, kButtonWidth, height);
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.willActivateDefaultAction) {
        self.willActivateDefaultAction = NO;
        [self userPressedButton:[self.buttons firstObject]];
        *targetContentOffset = CGPointZero;
        // Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }

    if (scrollView.contentOffset.x >= (kButtonWidth * self.buttons.count) / 2.0f) {
        targetContentOffset->x = kButtonWidth * self.buttons.count;
        self.isShowingMenu = YES;
    } else {
        *targetContentOffset = CGPointZero;
        // Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
        self.isShowingMenu = NO;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:THXTableViewCellsShouldHideMenu object:self];
}


@end
