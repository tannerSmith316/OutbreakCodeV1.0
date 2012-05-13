//
//  cReconnectViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 5/13/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cReconnectViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"

@implementation cReconnectViewController
@synthesize _reconnectIndicator;
@synthesize _password;
@synthesize _username;
@synthesize _playerMGR;
@synthesize _retryButton;

- (id)initWithUsername:(NSString *)username WithPassword:(NSString *)password {
    self = [super init];
    if (self != nil) 
    {
        _playerMGR = [[cPlayerManager alloc] init];
        self._playerMGR.delegate = self;
        self._username = username;
        self._password = password;
    }
    return self;
}

- (void)dealloc {
    [_playerMGR release];
    [super dealloc];
}

- (IBAction)QuitButtonPressed:(id)sender {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    [player._appDel.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)RetryButtonPressed:(id)sender {
    
    [_playerMGR LoginWithUsername:self._username Password:self._password];
	[_retryButton setEnabled:FALSE];
    [self._reconnectIndicator startAnimating];
}

- (void)UICallback:(BOOL)success errorMsg:(NSString *)errMsg {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    [self._reconnectIndicator stopAnimating];
    _retryButton.enabled = TRUE;
    if (success)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"Successfully Reconnected" delegate:nil cancelButtonTitle:@"Woot" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [player._appDel.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Failed to Reconnect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationItem.hidesBackButton = TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    self._reconnectIndicator.hidesWhenStopped = TRUE;
   
    [player ResetInstance];
    [self._retryButton setTitle:@"" forState:UIControlStateDisabled];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


@end
