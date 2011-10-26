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
    NSNumber *userId;
    
    /**
     The email associated with this user object.
     */
    NSString *email;
    
    /**
     The password for this user when registering.
     */
    NSString *password;
    
    /**
     The password confirmation for the user when registering.
     */
    NSString *passwordConfirmation;
    
    /**
     The user's first name
     */
    NSString *firstname;
    
    /**
     The user's last name
     */
    NSString *lastname;
    
    /**
     A key for accessing the site via APIs
     */
    NSString *apiKey;
}

@property (nonatomic,retain) NSNumber *userId;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *passwordConfirmation;
@property (nonatomic,retain) NSString *firstname;
@property (nonatomic,retain) NSString *lastname;
@property (nonatomic,retain) NSString *apiKey;

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

