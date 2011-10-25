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

@implementation AppUser

@synthesize userId = _id, email = _email, password = _password, passwordConfirmation = _password_confirmation, firstname = _firstname, lastname = _lastname;

+(void)authenticateUser:(NSString *)email 
           withPassword:(NSString *)password
             requestDelegate:(id)delegate;
{
    // setup the request
    NSURL *authenticationUrl = [NSURL URLWithString:@"http://localhost:3000/sessions.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:authenticationUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString *postData = [NSString stringWithFormat:@"{\"user\": { \"email\": \"%@\", \"password\": \"%@\" }}", email, password];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AppUser *user = [[self alloc] init];
    
    // set the completion callback
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        int responseCode = [request responseStatusCode];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        
        // if user errors
        if(responseCode == 201) {
            NSDictionary *userData = [responseData objectForKey:@"user"];
            user.userId = [[userData objectForKey:@"id"] copy];
            user.firstname = [[userData objectForKey:@"firstname"] copy];
            user.lastname = [[userData objectForKey:@"lastname"] copy];
            user.email = [[userData objectForKey:@"email"] copy];
            
            [parser release];
            NSLog(@"User logged in with id=%@, firstname=%@, lastname=%@, email=%@", user.userId, user.firstname, user.lastname, user.email);
            
            [delegate loginComplete:user];
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

- (void)register:(id)delegate
{
    // setup the request
    NSURL *registerUrl = [NSURL URLWithString:@"http://localhost:3000/users.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:registerUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // set the post data
    NSString *postData = [NSString stringWithFormat:@"{\"user\": { \"email\": \"%@\", \"password\": \"%@\", \"password_confirmation\":\"%@\", \"firstname\":\"%@\", \"lastname\":\"%@\" }}", self.email, self.password, self.passwordConfirmation, self.firstname, self.lastname];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set the completion callback
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        int responseCode = [request responseStatusCode];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        
        if(responseCode == 201) {
            NSDictionary *userData = [responseData objectForKey:@"user"];
            self.userId = [[userData objectForKey:@"id"] copy];
            
            [parser release];
            NSLog(@"User created with id=%@, firstname=%@, lastname=%@, email=%@", self.userId, self.firstname, self.lastname, self.email);
            
            [delegate registrationComplete:self];
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

-(void)dealloc
{
    [self.userId release];
    [self.email release];
    [self.password release];
    [self.passwordConfirmation release];
    [self.firstname release];
    [self.lastname release];
    [super dealloc];
}

@end
