//
//  THXTableViewCellWithSwipeMenu.h
//  ferry
//
//  Created by Tom Henderson on 21/09/14.
//  Copyright (c) 2014 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const THXTableViewCellsShouldHideMenu;

@interface THXTableViewCellWithSwipeMenu : UITableViewCell

-(void)addButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;

@end
