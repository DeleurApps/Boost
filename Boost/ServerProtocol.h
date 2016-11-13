//
//  NSObject+ServerProtocol.h
//  Boost
//
//  Created by Stiven Deleur on 11/12/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServerProtocolDelegate.h"

@interface User : NSObject
@property NSString* username;
@property NSString* userid;
@property NSString* email;
@end

@interface Charity : NSObject
@property NSString* charityid;
@property NSString* name;
@property NSString* shortDescription;
@property NSString* fullDescription;
@property UIImage* icon;
@end

@interface Payment : NSObject
@property NSString* paymentid;
@property NSString* cardNumber;
@property NSString* cardCCV;
@property NSString* cardExpDate;
@end

@interface Donation : NSObject
@property NSString* pid;
@property NSString* transactionDate;
@property NSString* charityName;
@property NSNumber* amount;
@end



@interface ServerProtocol : NSObject

+(void) setUser: (User *) newUser;
//registration + authentication
+(void) registerUser: (NSString *) user email:(NSString *) email pass: (NSString *)pass delegate: (id<ServerProtocolDelegate>)delegate;
+(BOOL) userExists: (NSString *) user;
+(BOOL) userExistsByEmail: (NSString *) email;
+(void) signIn: (NSString *) username pass:(NSString *)pass delegate: (id<ServerProtocolDelegate>)delegate;

//charity info
+(void) getListOfCharities: (id<ServerProtocolDelegate>)delegate;
+(void) getCharityInfo: (NSString *)charityid delegate: (id<ServerProtocolDelegate>)delegate;


//payment
+(void) getPaymentMethods;
+(void) addPayment: (NSDictionary *) params;
+(void) updatePayment: (NSDictionary *) params;
+(void) removePayment: (NSString *) paymentid;

//donate
+(void) getPastDonations: (id<ServerProtocolDelegate>)delegate;
+(void) submitDonation: (NSNumber *) amount toCharity:(Charity *) charity delegate: (id<ServerProtocolDelegate>)delegate;

@end


