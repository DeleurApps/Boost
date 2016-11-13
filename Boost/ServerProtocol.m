//
//  NSObject+ServerProtocol.m
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import "ServerProtocol.h"

@implementation User
@end
@implementation Charity
@end
@implementation Payment
@end
@implementation Donation
@end

@implementation ServerProtocol
static User *user;
NSString *baseUrl = @"http://ec2-35-162-210-203.us-west-2.compute.amazonaws.com/";


+(void) setUser: (User *) newUser{
	NSLog(@"JNkgjsdbgkdgnlkseng");
	user = newUser;
}
+(void) post: (NSDictionary *) params url: (NSString *)subUrl HTTPMethod: (NSString *)HTTPMethod delegate: (id<ServerProtocolDelegate>)delegate{
	NSString *strData = @"";
	if (params != NULL){
		for (id key in params) {
			strData = [NSString stringWithFormat:@"%@%@=%@&", strData, key, [params objectForKey:key]];
		}
	}
	NSData *postData = [strData dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, subUrl]];
	[request setURL:url];
	[request setHTTPMethod:HTTPMethod];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		NSLog(@"requestReply: %@", requestReply);
		NSLog(@"response: %@", response);
		NSLog(@"requestError: %@", error);
		dispatch_async(dispatch_get_main_queue(), ^{
			[delegate urlRequestCompletion: data response: response error: error];
		});
	}] resume];


}

+(void) registerUser: (NSString *) user email:(NSString *) email pass: (NSString *)pass delegate: (id<ServerProtocolDelegate>)delegate{
	NSDictionary *params = @{@"email": email, @"username": user, @"password": pass};
	[self post:params url:@"register" HTTPMethod:@"POST" delegate: delegate];
}
+(BOOL) userExists: (NSString *) user{
	return NO;
}
+(BOOL) userExistsByEmail: (NSString *) email{
	return NO;
}
+(void) signIn: (NSString *) username pass:(NSString *)pass delegate: (id<ServerProtocolDelegate>)delegate{
	NSDictionary *params = @{@"username": username, @"password": pass};
	[self post:params url:@"login" HTTPMethod:@"POST" delegate: delegate];
}

//charity info
+(void) getListOfCharities: (id<ServerProtocolDelegate>)delegate{
	[self post:NULL url:@"organization/" HTTPMethod:@"GET" delegate: delegate];
}
+(void) getCharityInfo: (NSString *)charityid delegate: (id<ServerProtocolDelegate>)delegate{
	[self post:NULL url: [NSString stringWithFormat: @"organization/%@", charityid] HTTPMethod:@"GET" delegate: delegate];
}


//payment
+(void) getPaymentMethods{
}
+(void) addPayment: (NSDictionary *) params{
}
+(void) updatePayment: (NSDictionary *) params{
}
+(void) removePayment: (NSString *) paymentid{
}

//donate
+(void) getPastDonations: (id<ServerProtocolDelegate>)delegate{
	[self post:NULL url: [NSString stringWithFormat: @"donate/%@", user.username] HTTPMethod:@"GET" delegate: delegate];
}
+(void) submitDonation: (NSNumber *) amount toCharity:(Charity *) charity delegate: (id<ServerProtocolDelegate>)delegate{
	[self post:@{@"orgid": charity.charityid, @"amount": amount, @"username": user.username} url: @"donate" HTTPMethod:@"POST" delegate: delegate];
}


@end
