//
//  AppUser.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppUser : NSObject
{
@private
    /**
     The ID associated with this user
     */
    NSNumber *_id;
    
    /**
     The email associated with this user object.
     */
    NSString *_email;
    
    /**
     The password for this user when registering.
     */
    NSString *_password;
    
    /**
     The password confirmation for the user when registering.
     */
    NSString *_password_confirmation;
    
    /**
     The user's first name
     */
    NSString *_firstname;
    
    /**
     The user's last name
     */
    NSString *_lastname;
}

@property (retain) NSNumber *userId;
@property (retain) NSString *email;
@property (retain) NSString *password;
@property (retain) NSString *passwordConfirmation;
@property (retain) NSString *firstname;
@property (retain) NSString *lastname;

+ (AppUser *)sharedAppUser;

/**
 Helper which sets the username and password, then authenticates.
 
 @param username the username
 @param password the password
 @returns the user authenticated
 */
+ (void)authenticateUser:(NSString *)email 
            withPassword:(NSString *)password
              requestDelegate:(id)delegate;


/**
 Registers the user, returning a populated user model.
 */
- (void)registerWithDelegate:(id)delegate;

@end

@protocol AppUserLoginDelegate <NSObject>
- (void) loginComplete;
- (void) loginFailed:(NSArray *)errors;
@end

@protocol AppUserRegistrationDelegate <NSObject>
- (void) registrationComplete;
- (void) registrationFailed:(NSArray *)errors;
@end

