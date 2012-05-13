//
//  cMainScreenViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/3/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerManager.h"

@interface cMainScreenViewController : UIViewController<AsyncUICallback> {

	IBOutlet UIButton *_infectScreenButton;
	IBOutlet UIButton *_virusScreenButton;
	IBOutlet UILabel *_infectedWithLabel;
    IBOutlet UITextView *_enemyStatsView;
    
    //debug
    IBOutlet UIButton *_healButton;
    
    cPlayerManager *_playerMGR;
}

@property (nonatomic, retain)UITextView *_enemyStatsView;
@property (nonatomic, retain)UIButton *_infectScreenButton;
@property (nonatomic, retain)UIButton *_virusScreenButton;
@property (nonatomic, retain)UILabel *_infectedWithLabel;
@property (nonatomic, retain)cPlayerManager *_playerMGR;

//debug
@property (nonatomic, retain)UIButton *_healButton;

//Programmatically handled button event handler
- (void)LogoutBackButton;
//Interface builder button event handlers
- (IBAction)InfectScreenButtonPressed;
- (IBAction)VirusScreenButtonPressed;

//debug
- (IBAction)HealButtonPressed:(id)sender;

@end