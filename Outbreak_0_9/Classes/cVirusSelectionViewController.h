//
//  cVirusSelectionViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cVirus.h"


@interface cVirusSelectionViewController : UIViewController {

	IBOutlet UITableView *_virusSelectTable;
	IBOutlet UIButton *_createVirusButton;
	IBOutlet UIButton *_deleteVirusButton;
	IBOutlet UIButton *_selectVirusButton;
	NSArray *_viruses;
	
	IBOutlet UILabel *_currentVirusLabel;
	
	cVirus *_deletingVirus;
}

@property (nonatomic, retain)cVirus *_deletingVirus;
@property (nonatomic, retain)UITableView *_virusSelectTable;
@property (nonatomic, retain)UILabel *_currentVirusLabel;
@property (nonatomic, retain)NSArray *_viruses;

- (IBAction)CreateVirusButtonPressed;
- (IBAction)DeleteVirusButtonPressed;
- (IBAction)SelectVirusButtonPressed;



@end
