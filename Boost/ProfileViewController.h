//
//  ProfileViewController.h
//  Boost
//
//  Created by Stiven Deleur on 11/13/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerProtocolDelegate.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ServerProtocolDelegate>

@end
