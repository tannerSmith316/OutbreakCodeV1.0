//
//  cInfectViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/7/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerSingleton.h"

//UI controller that alows the user to see people in his area of infection
//and lets them select a person for infection
@interface cInfectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UILocationAsyncDelegate> {

	IBOutlet UITableView *_victimTable;
    //Array thats used to fill UITableView with data
	NSMutableArray *_victimArray;
}

@property (nonatomic, retain)NSMutableArray *_victimArray;

//Change to UIAlertView confirmation window and refresh table on a timer
- (IBAction)RefreshButtonPressed;

@end
