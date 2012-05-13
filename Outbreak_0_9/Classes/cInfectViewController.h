//
//  cInfectViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/7/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerSingleton.h"
#import "cVictim.h"

//UI controller that alows the user to see people in his area of infection
//and lets them select a person for infection
@interface cInfectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UILocationAsyncDelegate> {

	IBOutlet UITableView *_victimTable;
    IBOutlet UIProgressView *_cooldownProgress;
    IBOutlet UILabel *_cooldownLabel;
    //Array thats used to fill UITableView with data
	NSMutableArray *_victimArray;
    cVictim *_victimToInfect;
    
    NSTimer *_virusCDTimer;
    int _timerCount;
    BOOL _virusCooldown;
}

@property (nonatomic, retain)UILabel *_cooldownLabel;
@property (nonatomic, retain)cVictim *_victimToInfect;
@property (nonatomic, assign)int _timerCount;
@property (nonatomic, retain)UIProgressView *_cooldownProgress;
@property (nonatomic, retain)NSTimer *_virusCDTimer;
@property (nonatomic, assign)BOOL _virusCooldown;
@property (nonatomic, retain)NSMutableArray *_victimArray;

//Change to UIAlertView confirmation window and refresh table on a timer
- (IBAction)RefreshButtonPressed;

- (void)CDTimerFired;

@end
