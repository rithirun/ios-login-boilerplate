//
//  Inflector.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inflector : NSObject
  
/**
 By default, camelize converts strings to UpperCamelCase. If the argument to camelize with lower is set to YES then camelize produces lowerCamelCase.
 
 @param the input string
 @param YES to produce lowerCamelCase
 @return the resulting string
 */
//+ (NSString *)camelize:(NSString *)string usingLowerCase:(BOOL)useLowerCase;

//+ (NSString *)classify:(NSString *)string;

//+ (NSString *)constantize:(NSString *)string;

//+ (NSString *)dasherize:(NSString *)string;

/**
 Capitalizes the first word and turns underscores into spaces and strips a trailing “_id”, if any.
 
 @param the input string
 @return the resulting string
 */
+ (NSString *)humanize:(NSString *)string;

@end
