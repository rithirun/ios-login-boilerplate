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
    IBOutlet UIButton *logoutButton;
}

@property (nonatomic,retain) IBOutlet UILabel *userIdField;
@property (nonatomic,retain) IBOutlet UILabel *emailField;
@property (nonatomic,retain) IBOutlet UILabel *firstnameField;
@property (nonatomic,retain) IBOutlet UILabel *lastnameField;
@property (nonatomic,retain) IBOutlet UIButton *logoutButton;

- (IBAction)logoutPressed:(UIButton *)sender;

@end
