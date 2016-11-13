//
//  ViewController+RegisterViewController.m
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "RegisterViewController.h"
#import "ServerProtocol.h"
#import "Utils.h"
#import "FireActivityIndicator.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rocketLogo;
@property FireActivityIndicator *activityIndicator;

@end

@implementation RegisterViewController



- (void) viewDidLoad{
	[super viewDidLoad];
	_activityIndicator = [[FireActivityIndicator alloc] initWithSuperview:self.view];
}

- (IBAction)register {
	[self.view endEditing:YES];
	NSString *username = [_usernameTextField text];
	NSString *email = [_emailTextField text];
	NSString *pass = [_passTextField text];
	
	if ([username length] < 4){
		[Utils showSimpleAlertWithTitle: @"Username is too short." message:@"Please choose a different username." controller:self];
		return;
	}else if (![Utils isValidEmail:email]){
		[Utils showSimpleAlertWithTitle: @"Email is invalid." message:@"Please choose a different email." controller:self];
		return;
	}else if ([ServerProtocol userExists:username]){
		[Utils showSimpleAlertWithTitle: @"Username is taken." message:@"Please choose a different username." controller:self];
		return;
		
	}else if ([ServerProtocol userExistsByEmail:email]){
		[Utils showSimpleAlertWithTitle: @"Email is already used." message:@"Please sign in or use a different email." controller:self];
		return;
		
	}else if ([pass length] < 6){
		[Utils showSimpleAlertWithTitle: @"Password is too short." message:@"Please choose a password at least 6 characters in length." controller:self];
		return;
	}
	[ServerProtocol registerUser:username email:email pass:pass delegate:self];
	[_activityIndicator animate];
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)keyboardDidShow
{
	[UIView animateWithDuration:0.25 animations:^{
		self.view.center = CGPointMake(self.view.center.x, self.view.center.y-216);
		_rocketLogo.center = CGPointMake(_rocketLogo.center.x, _rocketLogo.center.y-200);
	}];
	
}

- (void)keyboardDidHide
{
	[UIView animateWithDuration:0.25 animations:^{
		self.view.center = CGPointMake(self.view.center.x, self.view.center.y+216);
		_rocketLogo.center = CGPointMake(_rocketLogo.center.x, _rocketLogo.center.y+200);
	}];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[self keyboardDidShow];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[self keyboardDidHide];
	[self.view endEditing:YES];
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	if ([textField isEqual:_usernameTextField]){
		[_emailTextField becomeFirstResponder];
	}else if ([textField isEqual:_emailTextField]){
		[_passTextField becomeFirstResponder];
	}else{
		[textField resignFirstResponder];
	}
	return TRUE;
}

-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error{
	[_activityIndicator stopAnimate];
	BOOL success = YES;
	if (error){
		[Utils showSimpleAlertWithTitle: @"Unable to register." message:@"Please try again later." controller:self];
		return;
	}
	if (success){
		User *user = [[User alloc] init];
		user.username = [_usernameTextField text];
		user.email = [_emailTextField text];
		[ServerProtocol setUser:user];
		
		[self performSegueWithIdentifier:@"successfulRegistration" sender:NULL];
	}else{
		[Utils showSimpleAlertWithTitle: @"Registration failed." message:@"Please try again later." controller:self];
	}
}

@end
