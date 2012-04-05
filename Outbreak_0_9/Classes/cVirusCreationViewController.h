//
//  cVirusCreationViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cVirusCreationViewController : UIViewController {
	
	
	IBOutlet UITextField *_virusNameField;
	IBOutlet UITextView *_helpTextView;
	IBOutlet UISlider *_instantSlider;
	IBOutlet UISlider *_zoneSlider;
	IBOutlet UILabel *_instantValue;
	IBOutlet UILabel *_zoneValue;
	IBOutlet UIButton *_createButton;
	IBOutlet UISegmentedControl *_typeSwitcher;
	
	NSString *_virusName;
	NSString *_instantPoints;
	NSString *_zonePoints;
	NSString *_virusType;
	
	
}

@property (nonatomic, retain)NSString *_virusName;
@property (nonatomic, retain)NSString *_instantPoints;
@property (nonatomic, retain)NSString *_zonePoints;
@property (nonatomic, retain)NSString *_virusType;

@property (nonatomic, retain)UIButton *_createButton;
@property (nonatomic, retain)UITextField *_virusNameField;
@property (nonatomic, retain)UITextView *_helpTextView;
@property (nonatomic, retain)UISlider *_instantSlider;
@property (nonatomic, retain)UISlider *_zoneSlider;
@property (nonatomic, retain)UISegmentedControl *_typeSwitcher;
@property (nonatomic, retain)UILabel *_instantValue;
@property (nonatomic, retain)UILabel *_zoneValue;

- (IBAction)CreateButtonPressed;
- (IBAction)instantSliderChanged:(id)sender;
- (IBAction)zoneSliderChanged:(id)sender;
- (IBAction)HelpButtonPressed:(id)sender;

@end
