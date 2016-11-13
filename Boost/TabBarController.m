//
//  TabBarController.m
//  Boost
//
//  Created by Stiven Deleur on 11/13/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController()

@end
@implementation TabBarController

-(void) viewDidLoad{
	[super viewDidLoad];
	self.tabBar.backgroundImage = [[UIImage imageNamed:@"taskbar.png"]
									  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)resizingMode:UIImageResizingModeStretch];
	self.selectedIndex = 2;
	self.tabBar.tintColor = [UIColor colorWithRed:0.91 green:0.44 blue:0.32 alpha:1.0];
}

@end
