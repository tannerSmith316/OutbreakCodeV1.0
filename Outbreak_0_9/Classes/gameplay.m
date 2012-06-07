//
//  gameplay.m
//  agame
//
//  Created by ari d on 08/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "gameplay.h"
#import <AVFoundation/AVFoundation.h>
#import "cPlayerSingleton.h"


@implementation gameplay
@synthesize _image1;
@synthesize _image2;
@synthesize _image3;
@synthesize _images;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self._images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	int deltaTokens;
	deltaTokens = totalmoney - startMoney;
	NSLog(@"start:%d end:%d", startMoney, totalmoney);
	player._deltaTokens = [NSNumber numberWithInt:deltaTokens];
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self randomnumber];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)mainwindow{
    
	[self dismissModalViewControllerAnimated:YES];
}
-(void)randomnumber
{    
    
    
   // AudioServicesPlaySystemSound(play);    
    
    if (totalmoney<=4) {
        moneywon.text=[[NSString alloc] initWithFormat:@""];        
        currentmoney.text=[[NSString alloc] initWithFormat:@"Need 5 tokens to play"];
        totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney];        
        playbuttom.enabled=NO;
      
        
       
        
        
        
    }
    else{
    moneywon.text=[[NSString alloc] initWithFormat:@""];
    
    playbuttom.enabled=NO;        
    
    rnumber1 =arc4random() %9;
        rnumber2=arc4random()%9;
    rnumber3=arc4random()%9;
    /*    num1.text=[[NSString alloc]initWithFormat:@"%d",rnumber1]; */
    
    
    //num2.text=[[NSString alloc]initWithFormat:@"%d",rnumber2];
    //num3.text=[[NSString alloc]initWithFormat:@"%d",rnumber3];
    
    rotatetimer=[[NSTimer alloc]init];
    
    rotatetimer=[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerrotate) userInfo:nil repeats:YES];
    }
    
    
}

-(void) timerrotate
{
    value+=1;
    
    //num1.text=[[NSString alloc]initWithFormat:@"%d",value];
    if (value<=10) {
    
        //AudioServicesPlaySystemSound(playbutt);        
        //[audio play];
        if (counter<=10) {
            randisp=arc4random()%9;
            //num1.text=[[NSString alloc]initWithFormat:@"%d",randisp];
			[self._image1 setBackgroundImage:[_images objectAtIndex:randisp] forState:UIControlStateNormal];
			 [self.view addSubview:_image1];
            randisp=arc4random()%9;
            //num2.text=[[NSString alloc]initWithFormat:@"%d",randisp];
			 [self._image2 setBackgroundImage:[_images objectAtIndex:randisp] forState:UIControlStateNormal];
			  [self.view addSubview:_image2];
            randisp=arc4random()%9;
            //num3.text=[[NSString alloc]initWithFormat:@"%d",randisp];
			  [self._image3 setBackgroundImage:[_images objectAtIndex:randisp] forState:UIControlStateNormal];
			   [self.view addSubview:_image3];

            counter+=1;
            if (counter==10) {
                counter=0;
            }
        }
        
        
        
    }
    else
    {
        [rotatetimer invalidate];
        //num1.text=[[NSString alloc]initWithFormat:@"%d",rnumber1];
		[self._image1 setBackgroundImage:[_images objectAtIndex:rnumber1] forState:UIControlStateNormal];
		 [self.view addSubview:_image1];
        //num2.text=[[NSString alloc]initWithFormat:@"%d",rnumber2];
		 [self._image2 setBackgroundImage:[_images objectAtIndex:rnumber2] forState:UIControlStateNormal];
		  [self.view addSubview:_image2];
        //num3.text=[[NSString alloc]initWithFormat:@"%d",rnumber3];
		  [self._image3 setBackgroundImage:[_images objectAtIndex:rnumber3] forState:UIControlStateNormal];
		   [self.view addSubview:_image3];
     /* 
        rnumber1=1;
        rnumber2=2;
        rnumber3=3;
        */
        
        if (totalmoney<=0) {
            
        
            currentmoney.text=[[NSString alloc] initWithFormat:@"You Have no money to play"];
            totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
            playbuttom.enabled=NO;

        }
        
        else  
		{
            
        
        
        if(rnumber1==rnumber2&&rnumber2==rnumber3)
		{
                       
            if (rnumber1==0) 
			{
                moneywons=50;
            }
            else if(rnumber1==1)
			{
                moneywons=100;
            }
            else if(rnumber1==2)
			{
                moneywons=50;
            }
            else if(rnumber1==3){
                moneywons=50;
            }
            else if(rnumber1==4){
                moneywons=100;
            }
            else if(rnumber1==5){
                moneywons=500;
            }
            else if(rnumber1==6){
                moneywons=200;
            }
            else if(rnumber1==7){
                moneywons=800;
            }
            else if(rnumber1==8){
                moneywons=300;
            }
            else if(rnumber1==9){
                moneywons=1000;
            }
              
            
            
            
            
            
            
            totalmoney +=moneywons;
            moneywon.text=[[NSString alloc] initWithFormat:@"You Have Won %d$",moneywons];
            
            currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
            totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
            playbuttom.enabled=YES;
            
        }
        else if (rnumber1==rnumber2) 
		{
            moneywons=10;
            totalmoney +=moneywons;
            moneywon.text=[[NSString alloc] initWithFormat:@"You Have Won %d$",moneywons];
            
            currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
            totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
            playbuttom.enabled=YES;
            
            
            

            
        }
        else if(rnumber2==rnumber3)
        {
            moneywons=10;
            totalmoney +=moneywons;
            moneywon.text=[[NSString alloc] initWithFormat:@"You Have Won %d$",moneywons];
            
            currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
            totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
            playbuttom.enabled=YES;
            
            

        
        }
        else 
		{
			moneywon.text=[[NSString alloc] initWithFormat:@"You Have Lost %d $",5];
            totalmoney-=5;
            currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
            totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
            playbuttom.enabled=YES;
		}
        
        
        
        
        }
            
       
     //   AudioServicesRemoveSystemSoundCompletion(play);
        value=0;
        
    }
    

    
    



}
-(void)reset{
    
    
    /*
    totalmoney=50;
    moneywon.text=[[NSString alloc] initWithFormat:@""];        
    currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
    totaldisp.text=[[NSString alloc] initWithFormat:@"$%d",totalmoney]; 
    num1.text=@"1";
    num2.text=@"1";
    num3.text=@"1";
    playbuttom.enabled=YES;
*/
}

-(void)volumeonoff
{

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad
{
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	startMoney = [player._tokens intValue] + [player._deltaTokens intValue];
    
	totalmoney = startMoney;

    
    UIImage *image11 = [UIImage imageNamed:@"one.png"];
	UIImage *image22 = [UIImage imageNamed:@"two.png"];
	UIImage *image33 = [UIImage imageNamed:@"three.png"];
	UIImage *image44 = [UIImage imageNamed:@"four.png"];
	UIImage *image55 = [UIImage imageNamed:@"five.png"];
	UIImage *image66 = [UIImage imageNamed:@"six.png"];
	UIImage *image77 = [UIImage imageNamed:@"seven.png"];
	UIImage *image88 = [UIImage imageNamed:@"eight.png"];
	UIImage *image99 = [UIImage imageNamed:@"nine.png"];
	[self._images addObject:image11];
	[self._images addObject:image22];
	[self._images addObject:image33];
	[self._images addObject:image44];
	[self._images addObject:image55];
	[self._images addObject:image66];
	[self._images addObject:image77];
	[self._images addObject:image88];
	[self._images addObject:image99];
	
	self._image1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self._image1.frame=CGRectMake(5, 10, 90, 90);
	[_image1 setBackgroundImage:[_images objectAtIndex:0] forState:UIControlStateNormal];
	[self.view addSubview:_image1];
	
	self._image2 = [UIButton buttonWithType:UIButtonTypeCustom];
	_image2.frame=CGRectMake(115, 10, 90, 90);
	[_image2 setBackgroundImage:[_images objectAtIndex:0] forState:UIControlStateNormal];
	[self.view addSubview:_image2];
	
	self._image3 = [UIButton buttonWithType:UIButtonTypeCustom];
	_image3.frame=CGRectMake(225, 10, 90, 90);
	[_image3 setBackgroundImage:[_images objectAtIndex:0] forState:UIControlStateNormal];
	[self.view addSubview:_image3];

    
    totaldisp=[[UILabel alloc]initWithFrame:CGRectMake(220, 120, 90, 60)];
    totaldisp.backgroundColor=[UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:0.5];
    totaldisp.layer.cornerRadius = 14;
    [totaldisp setFont:[UIFont fontWithName:@"American Typewriter" size:20]];
    totaldisp.textAlignment = UITextAlignmentCenter;
    totaldisp.textColor=[UIColor whiteColor];
    totaldisp.text=[[NSString alloc]initWithFormat:@"$%d",totalmoney];
    totaldisp.layer.borderColor = [UIColor blackColor].CGColor;
    totaldisp.layer.borderWidth = 5.0;
    
    [self.view addSubview:totaldisp];
    [totaldisp release];
   
    
     
   
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"darkback.jpg"]];
      
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    [backgroundImage release]; 
     
	
    
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(250, 300, 65 , 65);
    [backbutton setTitle:@"" forState:UIControlStateNormal];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"back.png"];
    [backbutton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(mainwindow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    
    playbuttom=[UIButton buttonWithType:UIButtonTypeCustom];
    playbuttom.frame=CGRectMake(90, 300, 140 , 140);
    [playbuttom setTitle:@"" forState:UIControlStateNormal];
    UIImage *playbutton = [UIImage imageNamed:@"play.png"];
    
    [playbuttom setBackgroundImage:playbutton forState:UIControlStateNormal];
    //[playbutton release];
    [playbuttom addTarget:self action:@selector(randomnumber) forControlEvents:UIControlEventTouchUpInside];
   
    
    currentmoney=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 200, 60)];
     moneywon=[[UILabel alloc]initWithFrame:CGRectMake(65, 230, 250, 20)];
    moneywon.textColor=[UIColor whiteColor];
    moneywon.backgroundColor=[UIColor clearColor];
    [moneywon setFont:[UIFont fontWithName:@"American Typewriter" size:20]];    
    
    
    currentmoney.text=[[NSString alloc] initWithFormat:@"You Have Total"];
    currentmoney.textColor=[UIColor whiteColor];
    currentmoney.backgroundColor=[UIColor clearColor];
    [currentmoney setFont:[UIFont fontWithName:@"American Typewriter" size:25]];
    currentmoney.lineBreakMode = UILineBreakModeWordWrap;
    currentmoney.numberOfLines = 2;
    
    /*
    UIButton *resetbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    resetbutton.frame=CGRectMake(5, 400, 65 , 65);
    [resetbutton setTitle:@"" forState:UIControlStateNormal];
    UIImage *resetbutt = [UIImage imageNamed:@"reset.png"];
    
    [resetbutton setBackgroundImage:resetbutt forState:UIControlStateNormal];
    [resetbutton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetbutton];
  //  [resetbutt release];
    //[resetbutton release];

    */
    
   
    
    [self.view addSubview:playbuttom];
    [self.view addSubview:currentmoney];
    [self.view addSubview:moneywon];

    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
