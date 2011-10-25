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

@implementation AppUser

@synthesize userId = _id, email = _email, password = _password, passwordConfirmation = _password_confirmation, firstname = _firstname, lastname = _lastname;

+(AppUser *)authenticateUser:(NSString *)email 
           withPassword:(NSString *)password
{
    AppUser *user = [[self alloc] init];
    // setup the request
    NSURL *authenticationUrl = [NSURL URLWithString:@"http://localhost:3000/sessions.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:authenticationUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString *postData = [NSString stringWithFormat:@"{\"user\": { \"email\": \"%@\", \"password\": \"%@\" }}", email, password];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // execute the request
    [request startSynchronous];
    
    // capture any errors
    NSError *error = [request error];
    
    // no errors, parse response
    if(!error) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        NSDictionary *userData = [responseData objectForKey:@"user"];
        
        user.userId = [[userData objectForKey:@"id"] copy];
        user.firstname = [[userData objectForKey:@"firstname"] copy];
        user.lastname = [[userData objectForKey:@"lastname"] copy];
        user.email = [[userData objectForKey:@"email"] copy];
        
        [parser release];
        NSLog(@"User logged in with id=%@, firstname=%@, lastname=%@, email=%@", user.userId, user.firstname, user.lastname, user.email);
    }
    return user;
}

- (AppUser *)register
{
    // setup the request
    NSURL *registerUrl = [NSURL URLWithString:@"http://localhost:3000/users.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:registerUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // set the post data
    NSString *postData = [NSString stringWithFormat:@"{\"user\": { \"email\": \"%@\", \"password\": \"%@\", \"password_confirmation\":\"%@\", \"firstname\":\"%@\", \"lastname\":\"%@\" }}", self.email, self.password, self.passwordConfirmation, self.firstname, self.lastname];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // execute the request
    [request startSynchronous];
    
    // capture any errors
    NSError *error = [request error];
    
    // no errors, parse response
    if(!error) {
        NSString *response = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseData = [parser objectWithString:response];
        NSDictionary *userData = [responseData objectForKey:@"user"];
        
        self.userId = [[userData objectForKey:@"id"] copy];
        
        [parser release];
        
        NSLog(@"User created with id=%@, firstname=%@, lastname=%@, email=%@", self.userId, self.firstname, self.lastname, self.email);
    }
    
    return self;
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
