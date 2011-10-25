//
//  RootNavigationController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"

@interface RootNavigationController : UINavigationController
{
    @private
    AppUser *_user;
}

@property (retain) AppUser *user;

@end
