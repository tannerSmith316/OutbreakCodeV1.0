//
//  cVirusSelectionViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cVirus.h"
#import "cVirusManager.h"

//Shows a table of user's current virus's and allows the user
//to manipulate them directly(through a manager) or by presenting a new screen
@interface cVirusSelectionViewController : UIViewController<UIVirusAsyncDelegate> {

	IBOutlet UITableView *_virusSelectTable;
    IBOutlet UITextView *_virusStatsText;
	IBOutlet UIButton *_createVirusButton;
	IBOutlet UIButton *_deleteVirusButton;
	IBOutlet UIButton *_selectVirusButton;
    IBOutlet UILabel *_currentVirusLabel;
    
    //Array of player viruses for populating UITableView
	NSArray *_viruses;
	
    //Safe local save for virus being dealt with
	cVirus *_deletingVirus;
    
    //Manager for sending data to
	cVirusManager *_virusMGR;
}

@property (nonatomic, retain)IBOutlet UITextView *_virusStatsText;
@property (nonatomic, retain)IBOutlet UIButton *_createVirusButton;
@property (nonatomic, retain)IBOutlet UIButton *_deleteVirusButton;
@property (nonatomic, retain)IBOutlet UIButton *_selectVirusButton;
@property (nonatomic, retain)UITableView *_virusSelectTable;
@property (nonatomic, retain)UILabel *_currentVirusLabel;
@property (nonatomic, retain)cVirusManager *_virusMGR;
@property (nonatomic, retain)cVirus *_deletingVirus;
@property (nonatomic, retain)NSArray *_viruses;

- (IBAction)CreateVirusButtonPressed;
- (IBAction)DeleteVirusButtonPressed;
- (IBAction)SelectVirusButtonPressed;

@end
