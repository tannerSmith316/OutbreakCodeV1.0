//
//  cConnectionViewController.h
//  Outbreak_0_9
//
//  Created by Tanner Smith on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerManager.h"

@interface cConnectionViewController : UIViewController<AsyncUICallback> {
    
    cPlayerManager *_playerMGR;
    IBOutlet UIButton *_retryButton;
    IBOutlet UIButton *_quitButton;
    IBOutlet UIActivityIndicatorView *_reconnectIndicator;
    
    NSString *_username;
    NSString *_password;
    
}

@property (nonatomic, retain)UIButton *_retryButton;
@property (nonatomic, retain)cPlayerManager *_playerMGR;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;
@property (nonatomic, retain)UIActivityIndicatorView *_reconnectIndicator;

//Runs a connection test POST and returns the user
//to the previous screen if succesful
- (IBAction)RetryButtonPressed:(id)sender;
//Returns user to login screen
- (IBAction)QuitButtonPressed:(id)sender;

- (id)initWithUsername:(NSString *)username WithPassword:(NSString *)password;


@end
