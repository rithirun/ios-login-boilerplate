//
//  AppUser.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "AppUser.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "RailsUtils.h"
#import "SynthesizeSingleton.h"

@implementation AppUser

SYNTHESIZE_SINGLETON_FOR_CLASS(AppUser)

@synthesize userId, email, password, passwordConfirmation, firstname, lastname, apiKey;

- (void)dealloc
{
    [self.userId release];
    [self.email release];
    [self.password release];
    [self.passwordConfirmation release];
    [self.firstname release];
    [self.lastname release];
    [self.apiKey release];
    [super dealloc];
}

+ (void)authenticateUser:(NSString *)email 
           withPassword:(NSString *)password
             requestDelegate:(id)delegate;
{
    // setup the request
    NSDictionary *urlDict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Application URLs"];
    NSURL *authenticationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", 
                                                     [urlDict objectForKey:@"Base"],
                                                     [urlDict objectForKey:@"Sessions"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:authenticationUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSArray *keys = [NSArray arrayWithObjects:@"email", @"password", nil];
    NSArray *values = [NSArray arrayWithObjects:email, password, nil];
    NSDictionary *userData = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *postData = [NSDictionary dictionaryWithObject:userData forKey:@"user"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *postBody = [jsonWriter stringWithObject:postData];
    [request appendPostData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonWriter release];
    
    AppUser *user = [self sharedAppUser];
    
    // set the completion callback
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        int responseCode = [request responseStatusCode];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        
        // if user errors
        if(responseCode == 201) {
            NSDictionary *userData = [responseData objectForKey:@"user"];
            user.userId = [userData objectForKey:@"id"];
            user.firstname = ([[userData objectForKey:@"firstname"] isKindOfClass:[NSNull class]]) ? @"" : [userData objectForKey:@"firstname"];
            user.lastname = ([[userData objectForKey:@"lastname"] isKindOfClass:[NSNull class]]) ? @"" : [userData objectForKey:@"lastname"];
            user.email = ([[userData objectForKey:@"email"] isKindOfClass:[NSNull class]]) ? @"" : [userData objectForKey:@"email"];
            user.apiKey = [userData objectForKey:@"api_key"];
            
            [parser release];
            NSLog(@"User logged in with id=%@, firstname=%@, lastname=%@, email=%@, apiKey=%@", user.userId, user.firstname, user.lastname, user.email, user.apiKey);
            
            [delegate loginComplete];
        } else {
            [delegate loginFailed:[RailsUtils errorsArrayFromJson:responseData]];
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
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // set the post data
    NSArray *keys = [NSArray arrayWithObjects:@"email", @"password", @"password_confirmation", @"firstname", @"lastname", nil];
    NSArray *values = [NSArray arrayWithObjects:self.email, self.password, self.passwordConfirmation, self.firstname, self.lastname, nil];
    NSDictionary *userData = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *postData = [NSDictionary dictionaryWithObject:userData forKey:@"user"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *postBody = [jsonWriter stringWithObject:postData];
    [request appendPostData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    [jsonWriter release];
    
    // set the completion callback
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        int responseCode = [request responseStatusCode];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        
        if(responseCode == 201) {
            NSDictionary *userData = [responseData objectForKey:@"user"];
            self.userId = [userData objectForKey:@"id"];
            self.apiKey = [userData objectForKey:@"api_key"];
            
            [parser release];
            NSLog(@"User created with id=%@, firstname=%@, lastname=%@, email=%@, apiKey=%@", self.userId, self.firstname, self.lastname, self.email, self.apiKey);
            
            [delegate registrationComplete];
        } else {
            [delegate registrationFailed:[RailsUtils errorsArrayFromJson:responseData]];
        }
    }];
    
    // set the failure callback
    [request setFailedBlock:^{
        [delegate registrationFailed:[NSArray arrayWithObjects:[[request error] localizedDescription], nil]];
    }];
    
    // execute the request
    [request startAsynchronous];
}

@end
