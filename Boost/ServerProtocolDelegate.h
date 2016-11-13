//
//  ServerProtocolDelegate.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerProtocolDelegate <NSObject>
-(void)urlRequestCompletion: (NSData*) data response: (NSURLResponse *) response error: (NSError *) error;
@end
