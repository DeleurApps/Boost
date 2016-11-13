//
//  ViewController.m
//  Boost
//
//  Created by Stiven Deleur on 11/11/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "ServerProtocol.h"
#import "FireActivityIndicator.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rocketLogo;
@property FireActivityIndicator *activityIndicator;


@end

@implementation LoginViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	_activityIndicator = [[FireActivityIndicator alloc] initWithSuperview:self.view];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}
- (IBAction)logIn {
	[self.view endEditing:YES];
	NSString *user = [_usernameTextField text];
	NSString *pass = [_passwordTextField text];
	if ([user length] == 0){
		[Utils showSimpleAlertWithTitle: @"Enter a username or email." message:@"" controller:self];
		return;
	}
	[ServerProtocol signIn:user pass:pass delegate:self];
	[_activityIndicator animate];
}
- (IBAction)forgotPassword:(id)sender {
	NSString *user = [_usernameTextField text];
	if ([user length] == 0){
		[Utils showSimpleAlertWithTitle: @"Enter a username or email." message:@"" controller:self];
		return;
	}
	[Utils showSimpleAlertWithTitle: @"Success." message:@"Instructions on how to reset your password have been sent by email." controller:self];
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
		[_passwordTextField becomeFirstResponder];
	}else{
		[textField resignFirstResponder];
	}
	return TRUE;
}

-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error{
	[_activityIndicator stopAnimate];
	BOOL success = YES;
	if (error){
		//[Utils showSimpleAlertWithTitle: @"Unable to sign in." message:@"Please try again later." controller:self];
		//return;
	}
	if (success){
		User *user = [[User alloc] init];
		user.username = [_usernameTextField text];
		[ServerProtocol setUser:user];
		
		[self performSegueWithIdentifier:@"successfulLogin" sender:NULL];
	}else{
		[Utils showSimpleAlertWithTitle: @"Incorrect username or password." message:@"Please try again." controller:self];
	}
}

@end
