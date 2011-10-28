//
//  SerializableObject.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/27/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "SerializableObject.h"
#import "SBJson.h"

@implementation SerializableObject

@synthesize objectName;
@synthesize serializableProperties;

- (void)dealloc
{
    [self.objectName release];
    [self.serializableProperties release];
    [super dealloc];
}

- (NSString *)toJson
{
    // assemble a dictionary of this objects properties
    NSMutableArray *objectKeys = [[NSMutableArray alloc] init];
    NSMutableArray *objectValues = [[NSMutableArray alloc] init];
    for (NSString *key in self.serializableProperties) {
        // add our object key
        if ([(NSString *)[self.serializableProperties objectForKey:key] isEqualToString:@""]) {
            [objectKeys addObject:key];
        } else {
            [objectKeys addObject:[self.serializableProperties objectForKey:key]];
        }
        
        // add our object value
        id value = [self performSelector:NSSelectorFromString(key)];
        if (value) {
            [objectValues addObject:value];
        } else {
            [objectValues addObject:[NSNull null]];
        }
    }
    
    // create the object data dictionary from the keys and values
    NSDictionary *objectData = [NSDictionary dictionaryWithObjects:objectValues forKeys:objectKeys];
    
    // create the json object with the object name
    NSDictionary *jsonData = [NSDictionary dictionaryWithObject:objectData forKey:self.objectName];
    
    // using the json writer, create the json string
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:jsonData];
    
    // cleanup memory
    [objectKeys release];
    [objectValues release];
    [jsonWriter release];
    
    // return our created string
    return jsonString;
}

- (void)fromJson:(NSString *)jsonString
{
    // parse the json string into a dictionary
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:jsonString];
    
    // get the object data
    NSDictionary *objectData = [jsonData objectForKey:self.objectName];
    
    // parse through each piece of data, setting locally
    for (NSString *objectKey in objectData) {        
        // if the json data key has a translation to our property
        if ([[self.serializableProperties allValues] containsObject:objectKey]) {
            // get the internal property name
            NSString *internalPropertyName = [[self.serializableProperties allKeysForObject:objectKey] lastObject];
            
            // set the value (if it responds to the getter)
            if ([self respondsToSelector:NSSelectorFromString(internalPropertyName)]) {
                [self setValue:[objectData objectForKey:objectKey] forKey:internalPropertyName];
            }            
            // if the object key is the same as our local property
        } else if([[self.serializableProperties allKeys] containsObject:objectKey]) {
            // set the value
            if ([self respondsToSelector:NSSelectorFromString(objectKey)]) {
                [self setValue:[objectData objectForKey:objectKey] forKey:objectKey];
            }
        }
    }
    
    // cleanup memory
    [jsonParser release];
}

@end
