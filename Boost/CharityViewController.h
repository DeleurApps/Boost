//
//  CharityViewController.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerProtocol.h"
#import "ServerProtocolDelegate.h"

@interface CharityViewController : UIViewController <UITextFieldDelegate, ServerProtocolDelegate>
@property Charity* charity;

@end
