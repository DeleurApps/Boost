//
//  ViewController+RegisterViewController.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerProtocolDelegate.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, ServerProtocolDelegate>
-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error;

@end
