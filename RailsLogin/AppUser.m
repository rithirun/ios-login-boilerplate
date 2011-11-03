//
//  AppUser.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "AppUser.h"
#import "ASIHTTPRequest.h"
#import "RailsUtils.h"
#import "SynthesizeSingleton.h"

@implementation AppUser

@synthesize userId, email, password, passwordConfirmation, firstname, lastname, apiKey;

SYNTHESIZE_SINGLETON_FOR_CLASS(AppUser)

- (void)dealloc
{
    [userId release];
    [email release];
    [password release];
    [passwordConfirmation release];
    [firstname release];
    [lastname release];
    [apiKey release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        // set the object name (when serialized)
        objectName = @"user";
        // set the serializable properties and their serialized counterparts
        serializableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"id", @"userId",
                                  @"", @"email",
                                  @"", @"password",
                                  @"password_confirmation", @"passwordConfirmation",
                                  @"", @"firstname",
                                  @"", @"lastname",
                                  @"api_key", @"apiKey",
                                  nil];
    }
    return self;
}

- (void)setFirstname:(NSString *)aFirstname
{
    if ([aFirstname isEqual:[NSNull null]]) {
        firstname = @"";
    } else {
        firstname = aFirstname;
    }
}

- (void)setLastname:(NSString *)aLastname
{
    if ([aLastname isEqual:[NSNull null]]) {
        lastname = @"";
    } else {
        lastname = aLastname;
    }
}

- (void)setApiKey:(NSString *)anApiKey
{
    if ([anApiKey isEqual:[NSNull null]]) {
        apiKey = @"";
    } else {
        apiKey = anApiKey;
    }
}

+ (void)authenticateUser:(NSString *)email 
            withPassword:(NSString *)password
         requestDelegate:(id)delegate;
{
    // initialize the user
    AppUser *user = [self sharedAppUser];
    [user setEmail:email];
    [user setPassword:password];
    
    // setup the request
    NSDictionary *urlDict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Application URLs"];
    NSURL *authenticationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", 
                                                     [urlDict objectForKey:@"Base"],
                                                     [urlDict objectForKey:@"Sessions"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:authenticationUrl];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // add the post body
    NSString *postBody = [user toJson];
    [request appendPostData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];    
    
    // set the completion callback
    [request setCompletionBlock:^{        
        // response code 201 = Created
        if([request responseStatusCode] == 201) {
            // set user data from response
            [user fromJson:[request responseString]];
            
            NSLog(@"User logged in with id=%@, firstname=%@, lastname=%@, email=%@, apiKey=%@", [user userId], [user firstname], [user lastname], [user email], [user apiKey]);
            
            [delegate loginComplete];
        } else {
            [delegate loginFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
        }
    }];
    
    // set the failure callback
    [request setFailedBlock:^{
        [delegate loginFailed:[NSArray arrayWithObjects:[[request error] localizedDescription], nil]];
    }];
    
    // execute the request
    [request startAsynchronous];
}

- (void)registerWithDelegate:(id)delegate
{
    // setup the request
    NSDictionary *urlDict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Application URLs"];
    NSURL *registerUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                               [urlDict objectForKey:@"Base"], 
                                               [urlDict objectForKey:@"Users"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:registerUrl];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // set the post data
    NSString *postBody = [self toJson];
    [request appendPostData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set the completion callback
    [request setCompletionBlock:^{        
        if([request responseStatusCode] == 201) {
            // set user data from response
            [self fromJson:[request responseString]];
            NSLog(@"User created with id=%@, firstname=%@, lastname=%@, email=%@, apiKey=%@", userId, firstname, lastname, email, apiKey);
            
            [delegate registrationComplete];
        } else {
            [delegate registrationFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
        }
    }];
    
    // set the failure callback
    [request setFailedBlock:^{
        [delegate registrationFailed:[NSArray arrayWithObjects:[[request error] localizedDescription], nil]];
    }];
    
    // execute the request
    [request startAsynchronous];
}

- (BOOL)persist
{
    NSLog(@"Attempting to persist user logged in state.");
    // only attempt to persist if the user is authenticated
    if ([self isAuthenticated]) {
        NSString *error;
        
        // create the dictionary to store
        NSArray *keys = [NSArray arrayWithObjects:@"userId", @"email", @"firstname", @"lastname", @"apiKey", nil];
        NSArray *values = [NSArray arrayWithObjects:userId, email, firstname, lastname, apiKey, nil];
        NSDictionary *userDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        // save the dictionary to the local path
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:userDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        
        if (plistData) {
            [plistData writeToFile:[self userStoragePath] atomically:YES];
            NSLog(@"User data stored.");
            return YES;
        } else {
            NSLog(@"Error while persisting user: %@", error);
            [error release];
            return NO;
        }
        return YES;
    } else {
        NSLog(@"User has not logged in, therefore not stored.");
        return NO;
    }
}

- (void)logout
{
    // destory the persisted data
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:[self userStoragePath]]) {
        NSError *error;
        if (![manager removeItemAtPath:[self userStoragePath] error:&error]) {
            NSLog(@"Error removing file: %@", [error localizedDescription]);
            [error release];
        } else {
            NSLog(@"Removed persisted user data.");
        }
        
    } else {
        NSLog(@"No userdata file there, moving on.");
    }
    [manager release];
    
    
    // empty user data
    [userId release];
    [email release];
    [password release];
    [passwordConfirmation release];
    [firstname release];
    [lastname release];
    [apiKey release];
}

- (BOOL)isAuthenticated
{
    // if user is not authenticated
    if (!userId) {
        // attempt to read user in from storage
        NSString *errorDesc = nil;
        NSString *plistPath = [self userStoragePath];
        NSPropertyListFormat *format = nil;
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:plistPath]) {
            NSLog(@"UserData.plist does not exist, no login persisted");
            return NO;
        }
        
        NSData *plistXML = [fileManager contentsAtPath:plistPath];
        NSDictionary *userDict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:format errorDescription:&errorDesc];
        
        [fileManager release];
        if (!userDict) {
            NSLog(@"Error reading user property list: %@", errorDesc);
            return NO;
        } else {
            NSLog(@"Loading user data from persisted plist.");
            userId = [[userDict objectForKey:@"userId"] copy];
            email = [[userDict objectForKey:@"email"] copy];
            firstname = [[userDict objectForKey:@"firstname"] copy];
            lastname = [[userDict objectForKey:@"lastname"] copy];
            apiKey = [[userDict objectForKey:@"apiKey"] copy];
            return YES;
        }        
    } else {
        // user is authenticated
        return YES;
    }
    return NO;
}

- (NSString *)userStoragePath
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserData.plist"];
    return plistPath;
}

@end
