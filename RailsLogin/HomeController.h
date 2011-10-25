//
//  HomeController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNavigationController.h"

@interface HomeController : UIViewController
{
    IBOutlet UILabel *userIdField;
    IBOutlet UILabel *emailField;
    IBOutlet UILabel *firstnameField;
    IBOutlet UILabel *lastnameField;
}

@property (retain) IBOutlet UILabel *userIdField;
@property (retain) IBOutlet UILabel *emailField;
@property (retain) IBOutlet UILabel *firstnameField;
@property (retain) IBOutlet UILabel *lastnameField;

@end
