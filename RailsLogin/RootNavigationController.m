//
//  RootNavigationController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "RootNavigationController.h"

@implementation RootNavigationController

@synthesize user = _user;

-(void)dealloc
{
    [self.user release];
}

@end
