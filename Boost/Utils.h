//
//  Utils.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(void) showSimpleAlertWithTitle: (NSString *)title message: (NSString *)message controller:(UIViewController *)controller;
+(BOOL)isValidEmail: (NSString *)email;
+(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
+(NSString *)moneyNumberFrom: (NSNumber *) num;
@end
