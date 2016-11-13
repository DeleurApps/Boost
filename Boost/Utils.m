//
//  Utils.m
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void) showSimpleAlertWithTitle: (NSString *)title message: (NSString *)message controller:(UIViewController *)controller{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
																   message:message
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {}];
	
	[alert addAction:defaultAction];
	[controller presentViewController:alert animated:YES completion:nil];
}

+(BOOL)isValidEmail: (NSString *)email{
	return YES;
}

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
	NSLog(@"hiiii");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   NSLog(@"hellos");
							   if ( !error )
							   {
								   UIImage *image = [[UIImage alloc] initWithData:data];
								   completionBlock(YES,image);
							   } else{
								   NSLog(@"Download Image error: %@", error);
								   completionBlock(NO,nil);
							   }
						   }];
}
@end
