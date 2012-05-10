//
//  cInfectViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/7/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cPlayerSingleton.h"

@interface cInfectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UILocationAsyncDelegate> {

	IBOutlet UITableView *_victimTable;
	NSMutableArray *_victimArray;
}

@property (nonatomic, retain)NSMutableArray *_victimArray;


//Change to UIAlertView confirmation window and refresh table on a timer
- (IBAction)RefreshButtonPressed;

@end
