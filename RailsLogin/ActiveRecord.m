//
//  ActiveRecord.m
//  RailsLogin
//
//  Created by Brian Celenza on 11/3/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "ActiveRecord.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "RailsUtils.h"
#import "AppUser.h"

@implementation ActiveRecord

@synthesize delegate;

+ (void)findById:(NSString *)anId withDelegate:(id<ActiveRecordDelegate>)delegate
{
    // create the URL to request
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:[self singularURLPath], anId]];
    // initialize the request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestUrl];
    // add authorization (if applicable)
    [request addRequestHeader:@"X-ApiKey" value:[[AppUser sharedAppUser] apiKey]];
    
    // setup our completion block
    [request setCompletionBlock:^{
        // if response returned OK, process complete
        if ([request responseStatusCode] == 200) {
            // initialize the new record
            ActiveRecord *newRecord = [[[self alloc] init] autorelease];
            // populate it with json response
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *jsonData = [parser objectWithString:[request responseString]];
            [newRecord fromJson:jsonData];
            [parser release];
            
            // call the delegate
            if ([delegate respondsToSelector:@selector(findComplete:)]) {
                [delegate findComplete:newRecord];
            }
        } else {
            // response returned something other than 200, assumed error
            // call the delegate
            if ([delegate respondsToSelector:@selector(findFailed:)]) {
                [delegate findFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
            }
        }
        
    }];
    
    // setup our failed block
    [request setFailedBlock:^{
        if ([delegate respondsToSelector:@selector(findFailed:)]) {
            [delegate findFailed:[NSArray arrayWithObject:[[request error] localizedDescription]]];
        }
    }];
    
    // execute the request
    [request startAsynchronous];
}

+ (void)findAll:(NSDictionary *)args withDelegate:(id<ActiveRecordDelegate>)delegate
{
    // create the URL to request
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:[self pluralURLPath]]];
    // initialize the request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestUrl];
    // add authorization (if applicable)
    [request addRequestHeader:@"X-ApiKey" value:[[AppUser sharedAppUser] apiKey]];
    
    // setup our completion block
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSArray *responseRecords = [parser objectWithString:[request responseString]];
            NSArray *records = [NSArray array];
            // iterate through the response records and create new objects
            for (int i = 0; i < [responseRecords count]; i++) {
                ActiveRecord *record = [[[self alloc] init] autorelease];
                [record fromJson:[responseRecords objectAtIndex:i]];
                records = [records arrayByAddingObject:record];
            }
            [parser release];
            
            // call the delegate
            if ([delegate respondsToSelector:@selector(findAllComplete:)]) {
                [delegate findAllComplete:records];
            }
        } else {
            // response returned something other than 200, assumed error
            // call the delegate
            if ([delegate respondsToSelector:@selector(findAllFailed:)]) {
                [delegate findAllFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
            }
        }
    }];
    
    // setup our failed block
    [request setFailedBlock:^{
        if ([delegate respondsToSelector:@selector(findAllFailed:)]) {
            [delegate findAllFailed:[NSArray arrayWithObject:[[request error] localizedDescription]]];
        }
    }];
    
    // execute the request
    [request startAsynchronous];
}

+ (NSString *)singularURLPath
{
    return @"";
}

+ (NSString *)pluralURLPath
{
    return @"";
}

- (void)save
{
    NSString *urlString;
    NSString *httpVerb;
    
    // are we PUTing or POSTing? depends on if we have an id already
    NSNumber *myId = [self performSelector:NSSelectorFromString([[serializableProperties allKeysForObject:@"id"] lastObject])];
    if (myId != nil) {
        // updating existing record
        // get the update path
        urlString = [NSString stringWithFormat:[[self class] singularURLPath], [myId stringValue]];
        httpVerb = @"PUT";
    } else {
        urlString = [[self class] pluralURLPath];
        httpVerb = @"POST";
    }
    
    // initialize the request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:httpVerb];
    [request addRequestHeader:@"X-ApiKey" value:[[AppUser sharedAppUser] apiKey]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    // set the request body
    [request appendPostData:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setup the completion block
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200 || [request responseStatusCode] == 201) {
            // repopulate the data from the server
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *jsonData = [parser objectWithString:[request responseString]];
            [self fromJson:jsonData];
            [parser release];
            
            // call the delegate
            if ([(NSObject<ActiveRecordDelegate> *)delegate respondsToSelector:@selector(saveComplete:)]) {
                [(NSObject<ActiveRecordDelegate> *)delegate saveComplete:self];
            }
        } else {
            if ([(NSObject<ActiveRecordDelegate> *)delegate respondsToSelector:@selector(saveFailed:)]) {
                [(NSObject<ActiveRecordDelegate> *)delegate saveFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
            }
        }
    }];
    
    // setup the failed block
    [request setFailedBlock:^{
        if ([(NSObject<ActiveRecordDelegate> *)delegate respondsToSelector:@selector(saveFailed:)]) {
            [(NSObject<ActiveRecordDelegate> *)delegate saveFailed:[NSArray arrayWithObject:[[request error] localizedDescription]]];
        }
    }];
    
    // execute the request
    [request startAsynchronous];
}

- (void)remove
{
    // get the update path by perfoming the id getter
    NSString *urlString = [NSString stringWithFormat:[[self class] singularURLPath], [self performSelector:NSSelectorFromString([[serializableProperties allKeysForObject:@"id"] lastObject])]];
    
    // initialize the request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"DELETE"];
    [request addRequestHeader:@"X-ApiKey" value:[[AppUser sharedAppUser] apiKey]];
    
    // setup the completion block
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            // nothing else to do, call the delegate
            if ([(NSObject<ActiveRecordDelegate> *)delegate respondsToSelector:@selector(removeComplete:)]) {
                [(NSObject<ActiveRecordDelegate> *)delegate removeComplete:self];
            }
        } else {
            // response returned something other than 200, assumed error
            // call the delegate
            [(NSObject<ActiveRecordDelegate> *)delegate findAllFailed:[RailsUtils errorsArrayFromJson:[request responseString]]];
        }
    }];
    
    // setup the failed block
    [request setFailedBlock:^{
        if ([(NSObject<ActiveRecordDelegate> *)delegate respondsToSelector:@selector(removeFailed:)]) {
            [(NSObject<ActiveRecordDelegate> *)delegate findFailed:[NSArray arrayWithObject:[[request error] localizedDescription]]];
        }
    }];
    
    // execute the request
    [request startAsynchronous];
}

@end