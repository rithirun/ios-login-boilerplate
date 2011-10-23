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

@synthesize email = _email, firstname = _firstname, lastname = _lastname;

-(void)dealloc
{
    [self.email release];
    [self.firstname release];
    [self.lastname release];
}

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
        NSLog(@"%@", response);
    }
    return user;
}

@end
