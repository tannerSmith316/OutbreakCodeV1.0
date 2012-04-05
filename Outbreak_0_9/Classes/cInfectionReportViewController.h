//
//  cInfectionReportViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cInfectionReportViewController : UIViewController {
	
	IBOutlet UILabel *_reportLabel;
	NSString *_reportMessage;
}

@property (nonatomic, retain)NSString *_reportMessage;
@property (nonatomic, retain)UILabel *_reportLabel;

- (IBAction)DoneButtonPressed;

@end
