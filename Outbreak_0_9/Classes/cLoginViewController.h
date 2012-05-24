//
//  cLoginViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import	"cPlayerManager.h"
#import <UIKit/UIKit.h>

//This class contains the UI elements for the login screen
//along with a player manager for logical processing 
@interface cLoginViewController : UIViewController<UITextFieldDelegate, AsyncUICallback> {
    //UI - Interface Builder variables
	IBOutlet UITextField *_usernameField;
	IBOutlet UITextField *_passwordField;
	IBOutlet UIButton *_loginButton;
	IBOutlet UIActivityIndicatorView *_loginIndicator;
	IBOutlet UILabel *_loginError;
	IBOutlet UIButton *_registerButton;
	
    //Safe storage because UI fields can always be altered
    NSString *_username;
	NSString *_password;
    
    //Class thats sent messages for BOL operations
	cPlayerManager *_playerMGR;
    
    BOOL _didAttemptAutoLogin;
}

@property (nonatomic, assign)BOOL _didAttemptAutoLogin;
@property (nonatomic, retain)UITextField *_usernameField;
@property (nonatomic, retain)UITextField *_passwordField;
@property (nonatomic, retain)UIButton *_loginButton;
@property (nonatomic, retain)UIActivityIndicatorView *_loginIndicator;
@property (nonatomic, retain)UILabel *_loginError;
@property (nonatomic, retain)UIButton *_registerButton;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;
@property (nonatomic, retain)cPlayerManager *_playerMGR;


//Tied to UI Actions through Interface Builder
- (IBAction)LoginButtonPressed:(id)sender;
- (IBAction)RegisterButtonPressed:(id)sender;

@end
