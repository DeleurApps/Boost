//
//  CharitiesViewController.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ServerProtocolDelegate.h"

@interface CharitiesViewController: UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ServerProtocolDelegate>
@end
