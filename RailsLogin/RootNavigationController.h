//
//  RootNavigationController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootNavigationController : UINavigationController
{
    @private
    UIViewController *_homeController;
}

@property (retain) UIViewController *homeController;

- (void)pushHomeController;

@end
