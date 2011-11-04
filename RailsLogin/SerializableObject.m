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
    [objectName release];
    [serializableProperties release];
    [super dealloc];
}

- (NSString *)toJson
{
    // assemble a dictionary of this objects properties
    NSMutableArray *objectKeys = [[NSMutableArray alloc] init];
    NSMutableArray *objectValues = [[NSMutableArray alloc] init];
    for (NSString *key in serializableProperties) {
        // add our object key
        if ([(NSString *)[serializableProperties objectForKey:key] isEqualToString:@""]) {
            [objectKeys addObject:key];
        } else {
            [objectKeys addObject:[serializableProperties objectForKey:key]];
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
    NSDictionary *jsonData = [NSDictionary dictionaryWithObject:objectData forKey:objectName];
    
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

- (void)fromJson:(NSDictionary *)jsonData
{
    // get the object data
    NSDictionary *objectData = [jsonData objectForKey:objectName];
    
    // parse through each piece of data, setting locally
    for (NSString *objectKey in objectData) {        
        // if the json data key has a translation to our property
        if ([[serializableProperties allValues] containsObject:objectKey]) {
            // get the internal property name
            NSString *internalPropertyName = [[serializableProperties allKeysForObject:objectKey] lastObject];
            
            // set the value (if it responds to the getter)
            if ([self respondsToSelector:NSSelectorFromString(internalPropertyName)]) {
                [self setValue:[objectData objectForKey:objectKey] forKey:internalPropertyName];
            }            
            // if the object key is the same as our local property
        } else if([[serializableProperties allKeys] containsObject:objectKey]) {
            // set the value
            if ([self respondsToSelector:NSSelectorFromString(objectKey)]) {
                [self setValue:[objectData objectForKey:objectKey] forKey:objectKey];
            }
        }
    }
}

@end
