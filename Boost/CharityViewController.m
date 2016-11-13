//
//  CharityViewController.m
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "CharityViewController.h"
#import "Utils.h"

@interface CharityViewController()
@property (weak, nonatomic) IBOutlet UIView *charityDescriptionView;
@property (weak, nonatomic) IBOutlet UIView *rocketsView;
@property (weak, nonatomic) IBOutlet UIImageView *rocket1;
@property (weak, nonatomic) IBOutlet UIImageView *rocket2;
@property (weak, nonatomic) IBOutlet UIImageView *rocket3;
@property (weak, nonatomic) IBOutlet UIImageView *rocket4;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIView *moneyEntryView;
@property (weak, nonatomic) IBOutlet UIImageView *charityLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *charityNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *charityDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *boostedLabel;

@end
@implementation CharityViewController

BOOL screenDone = NO;
BOOL boostable = YES;

-(void) viewDidLoad{
	[super viewDidLoad];
	srandom((unsigned int)time(NULL));
	if (_charity){
		_charityNameLabel.text = _charity.name;
		_charityDescriptionTextView.text = _charity.fullDescription;
		_charityLogoImageView.image = _charity.icon;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

-(void)resetScreen{
	screenDone = NO;
	boostable = YES;
	[UIView animateWithDuration:2 animations:^{
		_charityDescriptionView.alpha = 1;
		_moneyEntryView.alpha = 1;
	}
	completion:^(BOOL finished){
		_rocketsView.center =CGPointMake(_rocketsView.center.x, _rocketsView.center.y+600);
		_rocketsView.alpha = 1;
	}];
	[UIView animateWithDuration:1 animations:^{
		_boostedLabel.alpha = 0;
	}];
}

-(void)flashRockets{
	if (screenDone){ [self resetScreen]; return; }
	[UIView animateWithDuration:0.04 animations:^{
		_rocket2.alpha = rand()%2;
		_rocket3.alpha = rand()%2;
		_rocket4.alpha = rand()%2;
	} completion:^(BOOL finished){ [self flashRockets]; }];
}
- (IBAction)pressBoost:(id)sender {
	if (!boostable){
		return;
	}
	boostable = NO;
	NSString *donationStr = _moneyTextField.text;
	if ([donationStr isEqualToString:@""]){
		donationStr = @"1.00";
	}
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterDecimalStyle;
	NSNumber *amount = [f numberFromString:donationStr];
	
	[ServerProtocol submitDonation:amount toCharity:_charity delegate:self];
}

-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error{
	BOOL success = YES;
	if (error){
		success = NO;
	}
	if (success){
		NSString *donationStr = _moneyTextField.text;
		if ([donationStr isEqualToString:@""]){
			donationStr = @"1.00";
		}
		_boostedLabel.text = [NSString stringWithFormat:@"YOU BOOSTED $%@!", donationStr];
		[UIView animateWithDuration:1 animations:^{
			_charityDescriptionView.alpha = 0;
			_moneyEntryView.alpha = 0;
		}];
		[UIView animateWithDuration:5 delay:1 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			_rocketsView.center = CGPointMake(_rocketsView.center.x, _rocketsView.center.y-600);
			_rocketsView.alpha = 0;
		} completion:^(BOOL finished){ screenDone = true;}];
		[self flashRockets];
		[UIView animateWithDuration:1 delay:1 options:0 animations:^{
			_boostedLabel.alpha = 1;
		} completion:NULL];
	}else{
		boostable = YES;
		[Utils showSimpleAlertWithTitle: @"Boost failed." message:@"Please try again later." controller:self];
	}
}

@end
