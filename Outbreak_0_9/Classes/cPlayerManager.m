//
//  cPlayerManager.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cPlayerManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cMainScreenViewController.h"

@implementation cPlayerManager

@synthesize delegate;

- (void)RegisterWithUsername:(NSString *)username Password:(NSString *)password {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	NSString *urlstring = [NSString stringWithFormat:@"%@createAccount.php",player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:username forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	
	[request setDidFinishSelector:@selector(RegisterDidFinished:)];
	[request setDidFailSelector:@selector(RegisterDidFailed:)];
	
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)RegisterDidFinished:(ASIHTTPRequest *)request {
	
	//Account name was not taken and has been registered for the user
	if ([[request responseString] isEqualToString:@"TRUE"])
	{
		[delegate UpdateCallBack:@"HURRY UP AND LOGIN YOU COW"];
	}
	//The request account name is already in use, advise user to choose another
	else
	{
		[delegate UpdateCallBack:@"PICK ANOTHER"];
	}
	
}

- (void)RegisterDidFailed:(ASIHTTPRequest *)request {
	
	[delegate UpdateCallBack:@"Cannot Connect to SERVER"];
	
}

- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Moves variables out to view controller
	player._username = username;
	player._password = password;
	
	NSString *urlstring = [NSString stringWithFormat:@"%@login.php",player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	NSLog(@"POST: Login; Username=%@ ; Password=%@", username, password);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:username forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	
	[request setDidFinishSelector:@selector(LoginDidFinished:)];
	[request setDidFailSelector:@selector(LoginDidFailed:)];
	
	[request setDelegate:self];
	[request startAsynchronous];
	
}



- (void)LoginDidFinished:(ASIHTTPRequest *)request {
	
	//Response will return TRUE or FALSE
	NSString *loginSuccess = [request responseString];
	
	//If the login doesnt fail
	if ( ![loginSuccess isEqualToString:@"FALSE"] )
	{
		
		cPlayerSingleton *player = [cPlayerSingleton GetInstance];
		
		//Save succesful credentials to flat file for auto-login
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
		NSString *successfulCredentials = [NSString stringWithFormat:@"%@\n%@", player._username, player._password];
		[successfulCredentials writeToFile:myFilePath atomically:YES];
		
		
		//Load JSON data into singleton
		NSString *jsonString = [NSString stringWithString:[request responseString]];
		//Parse the json
		NSLog(@"Login Succesful Return Packet: %@", jsonString);
		NSDictionary *deserializedData = [[NSDictionary alloc] init];
		deserializedData = [jsonString objectFromJSONString];
		
		[self parsePlayerJson:deserializedData];
		
		
		//Push main VC
		cMainScreenViewController *mainScreen = [[cMainScreenViewController alloc] init];
		mainScreen.title = @"Main";
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:mainScreen action:@selector(LogoutBackButton)];
		
		mainScreen.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		NSLog(@"POST: Login Succesful");
		
		[delegate CallBackLoginDidFinished];
	}
	else
	{
		NSLog(@"Invalid Login Credentials");
		[delegate CallBackLoginFailed];
	}
	
	
	//posted back here
	//if passed login check
	//
	
	
}

//Parses returned json and sets playsingleton with data retrieved
- (void)parsePlayerJson:(NSDictionary *)playerDict {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	NSMutableArray *viruses = [[NSMutableArray alloc] init];
	
	//Retrieve information from the deserialized json string
	NSDictionary *playerViruses = [playerDict objectForKey:@"viruses"];
	//Iterate through virus data
	for ( NSDictionary * each_virus in playerViruses ) 
	{
		NSString *virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		//Needs to retrieve more virus info
		cVirus *virus = [[cVirus alloc] init];
		virus._virusName = virusName;
		virus._owner = player._username;
		
		[viruses addObject:virus];
		[virus release];
	}
	//Set playerSingleton viruses
	player._viruses = viruses;
	
	
	
	NSDictionary *playerInfectedWith = [playerDict objectForKey:@"infected_with"];
	
	for( NSDictionary *each_virus in playerInfectedWith )
	{
		NSString *virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		NSString *virusOwner = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_owner"]];
		//Needs to retrieve more data
		
		cVirus *infectedWith = [[cVirus alloc] init];
		infectedWith._virusName = virusName;
		infectedWith._owner = virusOwner;
		//Set playersingleton infectedWith
		player._infectedWith = infectedWith;
	}
	
	
}

@end
