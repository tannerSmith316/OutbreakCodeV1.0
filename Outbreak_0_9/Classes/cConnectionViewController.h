//
//  cConnectionViewController.h
//  Outbreak_0_9
//
//  Created by Tanner Smith on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerManager.h"

@interface cConnectionViewController : UIViewController {
    
    cPlayerManager *_playerMGR;
    IBOutlet UIButton *_retryButton;
    IBOutlet UIButton *_quitButton;
    
}

//Runs a connection test POST and returns the user
//to the previous screen if succesful
- (IBAction)RetryButtonPressed:(id)sender;
//Returns user to login screen
- (IBAction)QuitButtonPressed:(id)sender;


@end
