//
//  ActiveRecord.h
//  Saboteur
//
//  Created by Brian Celenza on 11/3/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "SerializableObject.h"

@interface ActiveRecord : SerializableObject
{
    /**
     The delegate used for instance methods
     */
    id delegate;
}

@property (nonatomic,assign) id delegate;

/**
 Looks up and instantiates a new model with a given id
 
 @param an id to look up
 @param the delegate for the request
 */
+ (void)findById:(NSString *)anId withDelegate:(id)delegate;

/**
 Grabs all records given a set of request args and a delegate
 
 @param a dictionary of query string parameters
 @param the delegate for the request
 */
+ (void)findAll:(NSDictionary *)args withDelegate:(id)delegate;

/**
 Responsible for returning the URL string format for a single record. Used for 
 findById, save (when updating), and remove.
 e.g. http://localhost/widgets/%@.json
 
 @return the string to be used for formatting
 */
+ (NSString *)singularURLPath;

/**
 pluralURLPath is responsible for returning the URL string for plural records. 
 Used for findAll and save (when adding a new record)
 e.g. http://localhost/widgets.json
 */
+ (NSString *)pluralURLPath;

/**
 Adds or updates the record, depending on whether or not it has an existing ID.
 */
- (void)save;

/**
 Removes the record from the REST service. Delegate is responsible for releasing.
 */
- (void)remove;

@end

/**
 ActiveRecordDelegate is responsible for notifying the requestor when an operation
 has either completed or failed.
 */
@protocol ActiveRecordDelegate <NSObject>
@optional // all methods are optional here
/**
 Called when a record lookup has completed, and passes the record
 
 @param the loaded record
 */
- (void)findComplete:(ActiveRecord *)aRecord;

/**
 Called when a record lookup has failed, and passes an array of error strings
 
 @param an array of error strings
 */
- (void)findFailed:(NSArray *)errors;

/**
 Called when a set of records have been found, and passes those records
 
 @param the loaded records
 */
- (void)findAllComplete:(NSArray *)recordArray;

/**
 Called when a record lookup has failed, and passes an array of error strings
 
 @param an array of error strings
 */
- (void)findAllFailed:(NSArray *)errors;

/**
 Called when a record save has completed, and passes the record
 
 @param the saved record
 */
- (void)saveComplete:(ActiveRecord *)aRecord;

/**
 Called when a record save has failed, and passes an array of error strings
 
 @param an array of error strings
 */
- (void)saveFailed:(NSArray *)errors;

/**
 Called when a record deletion has completed, and passes the record. 
 IMPORTANT: The delegate is responsible for releasing the record from memory.
 
 @param the deleted record
 */
- (void)removeComplete:(ActiveRecord *)aRecord;

/**
 Called when a record deletion has failed, and passes an array of error strings
 
 @param an array of error strings
 */
- (void)removeFailed:(NSArray *)errors;
@end
