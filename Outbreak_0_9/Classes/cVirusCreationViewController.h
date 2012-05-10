//
//  cVirusCreationViewController.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cVirusManager.h"

//Has UI elements that allow custom creation of a new virus
@interface cVirusCreationViewController : UIViewController<UIVirusAsyncDelegate> {
	
	IBOutlet UITextField *_virusNameField;
	IBOutlet UITextView *_helpTextView;
	IBOutlet UISlider *_instantSlider;
	IBOutlet UISlider *_zoneSlider;
	IBOutlet UILabel *_instantValue;
	IBOutlet UILabel *_zoneValue;
	IBOutlet UIButton *_createButton;
	IBOutlet UISegmentedControl *_typeSwitcher;
	
    //Safe save because data in UI elements is volatile
	NSString *_virusName;
	NSString *_instantPoints;
	NSString *_zonePoints;
	NSString *_virusType;
	
	cVirusManager *_virusMGR;
	
}

@property (nonatomic, retain)cVirusManager *_virusMGR;
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
- (IBAction)HelpButtonPressed:(id)sender;
- (IBAction)instantSliderChanged:(id)sender;
- (IBAction)zoneSliderChanged:(id)sender;

@end
