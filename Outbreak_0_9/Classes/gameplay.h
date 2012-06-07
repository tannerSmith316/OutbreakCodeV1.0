//
//  gameplay.h
//  agame
//
//  Created by ari d on 08/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface gameplay : UIViewController {
	
	UIButton *_image1;
	UIButton *_image2;
	UIButton *_image3;
	
    UILabel *num1;
    UILabel *num2;
    UILabel *num3;

	int startMoney;
    int value;
      int rnumber1,rnumber2,rnumber3; 
    int counter;
    NSTimer *rotatetimer;
    UIButton *playbuttom; 
    int moneywons;
    int totalmoney;
    UILabel *currentmoney;
    UILabel *moneywon;
    UILabel *totaldisp;
    int randisp;
    NSString *spath;
 
    NSMutableArray *_images;
    

}

@property (nonatomic, retain)NSMutableArray *_images;
@property (nonatomic, retain)UIButton *_image1;
@property (nonatomic, retain)UIButton *_image2;
@property (nonatomic, retain)UIButton *_image3;

-(void)mainwindow;
-(void)randomnumber;
-(void) timerrotate;
-(void)reset;



@end
