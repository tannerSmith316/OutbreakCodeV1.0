//
//  cLoginViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cLoginViewController : UIViewController<UITextFieldDelegate> {
	IBOutlet UITextField *_usernameField;
	IBOutlet UITextField *_passwordField;
	IBOutlet UIButton *_loginButton;
	IBOutlet UIActivityIndicatorView *_loginIndicator;
	IBOutlet UILabel *_loginError;
	IBOutlet UIButton *_registerButton;
	
	NSString *_username;
	NSString *_password;

}

@property (nonatomic, retain)UITextField *_usernameField;
@property (nonatomic, retain)UITextField *_passwordField;
@property (nonatomic, retain)UIButton *_loginButton;
@property (nonatomic, retain)UIActivityIndicatorView *_loginIndicator;
@property (nonatomic, retain)UILabel *_loginError;
@property (nonatomic, retain)UIButton *_registerButton;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;

- (IBAction)LoginButtonPressed:(id)sender;
- (void)AttemptAutoLogin;
- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password;
- (IBAction)RegisterButtonPressed:(id)sender;

@end
