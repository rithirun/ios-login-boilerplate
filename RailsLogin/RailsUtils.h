//
//  RailsUtils.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailsUtils : NSObject

+ (NSArray *)errorsArrayFromJson:(NSDictionary *)errorsDict;
+ (NSString *)stringFromErrorsArray:(NSArray *)errors;

@end
