//
//  cMainScreenViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/3/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cMainScreenViewController : UIViewController {

	IBOutlet UIButton *_infectScreenButton;
	IBOutlet UIButton *_virusScreenButton;
	IBOutlet UILabel *_infectedWithLabel;
	IBOutlet UIButton *_hotspotButton;
}

@property (nonatomic, retain)UIButton *_infectScreenButton;
@property (nonatomic, retain)UIButton *_virusScreenButton;
@property (nonatomic, retain)UILabel *_infectedWithLabel;
@property (nonatomic, retain)UIButton *_hotspotButton;

- (void)LogoutBackButton;
- (IBAction)InfectScreenButtonPressed;
- (IBAction)VirusScreenButtonPressed;
- (IBAction)HotspotButtonPressed;

- (IBAction)HealInfection;

@end