//
//  FireActivityIndicator.m
//  Boost
//
//  Created by Stiven Deleur on 11/13/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "FireActivityIndicator.h"

@interface FireActivityIndicator()
@property UIView *superview;
@property UIView *view;
@end

@implementation FireActivityIndicator

- (id) initWithSuperview: (UIView*) superview{
	self = [super init];
	_superview = superview;
	UIImage *fireImage = [UIImage animatedImageNamed:@"fire-" duration:1];
	_view = [[UIView alloc] initWithFrame:_superview.frame];
	UIView *overlay = [[UIView alloc] initWithFrame:_superview.frame];
	overlay.backgroundColor = [UIColor blackColor];
	overlay.alpha = 0.3;
	UIImageView *fireImageView = [[UIImageView alloc] initWithImage:fireImage];
	fireImageView.center = _view.center;
	[_view addSubview:overlay];
	[_view addSubview:fireImageView];
	return self;
}

- (void) animate{
	
	[_superview addSubview:_view];
}

- (void) stopAnimate{
	[_view removeFromSuperview];
}

@end
