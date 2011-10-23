//
//  ViewController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    AppUser *user;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UILabel *registerLabel;
    IBOutlet UIView *waitingView;
}

- (void)loginFormSubmitted;

@property (nonatomic,retain) IBOutlet UITextField *usernameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) IBOutlet UILabel *registerLabel;
@property (nonatomic,retain) IBOutlet UIView *waitingView;
@property (nonatomic,retain) AppUser *user;

@end
