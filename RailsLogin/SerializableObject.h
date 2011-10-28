//
//  SerializableObject.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/27/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerializableObject : NSObject
{
    /**
     The object name to be represented when serialized (e.g. "User")
     */
    NSString *objectName;
    
    /** 
     A list of serializable properties on the object and their serialized counterparts
     */
    NSDictionary *serializableProperties;
}

@property (nonatomic,retain) NSString *objectName;
@property (nonatomic,retain) NSDictionary *serializableProperties;

/**
 Collects this objects name and properties and assembles them into a JSON representation
 
 @return the json string
 */
- (NSString *)toJson;

/**
 Uses a json string to set properties on the local object
 
 @param the json string
 */
- (void)fromJson:(NSString *)jsonString;

@end
