//
//  cPlayerManager.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cMainScreenViewController.h"
#import "cPlayerSingleton.h"
#import "cPlayerManager.h"

@implementation cPlayerManager
@synthesize delegate;

- (id)init {
	self = [super init];
	if (self != nil)
	{
        //Custom inits here
	}
	return self;	
}

/************************************************************
 * Purpose: To attempt to automatically log the user in using
 *   a credentials.txt file(in the documents directory) to by-pass
 *   the annoying login screen
 *
 * Entry: Called when the LoginViewController didLoad
 *
 * Exit: Will end at LoginDidFinished or LoginDidFailed depending
 *   on server connectivity
 ************************************************************/
- (void)AttemptAutoLogin {
	
    //Get local phone documents directory
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //Retrieve the document containing auto-login credentials
	NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
	NSString *myFileContents = [NSString stringWithContentsOfFile:myFilePath encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"Attempting AutoLogin");
    
    //If the file contains data, use it for logging in.
	if( [myFileContents length] != 0 )
	{
		NSArray *credentials = [myFileContents componentsSeparatedByString:@"\n"]; 
		NSString *usernameFromFile = [credentials objectAtIndex:0];
		NSString *passwordFromFile = [credentials objectAtIndex:1];
		NSLog(@"AutoLogin Credentials, Username:%@ ; Password:%@", usernameFromFile, passwordFromFile);
		
		[self LoginWithUsername:usernameFromFile Password:passwordFromFile];
	}
}

/************************************************************
 * Purpose: Send a POST request to web server requesting a login
 *   with the username and password parameters
 *
 * Entry: LoginViewController has sent a request from data supplied
 *   by the user
 *
 * Exit: Asynchronous request has been sent
 ************************************************************/
- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Saves data to player
	player._username = username;
	player._password = password;
	
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"PlayerPersister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodLogin", nil)];
	NSLog(@"POST: Login; Username=%@ ; Password=%@", username, password);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:username forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	
	[request setDidFinishSelector:@selector(LoginDidFinished:)];
	[request setDidFailSelector:@selector(LoginDidFailed:)];
	
	[request setDelegate:self];
	
	//SYNCHRONOUS FOR TESTING
	//[request startSynchronous];
	[request startAsynchronous];
	
}

/************************************************************
 * Purpose: If the user has sent succesful credentials, this function
 *   will save those credentials to a flat file and then parse the
 *   json packet saving the data to the playersingleton
 *
 * Entry: Succesfull connection to the webserver asynchronous request
 *   finished
 *
 * Exit: credentials saved and ParsePlayerJson has finished
 ************************************************************/
- (void)LoginDidFinished:(ASIHTTPRequest *)request {
	
	//Response will return TRUE or FALSE
	NSString *loginSuccess = [request responseString];
	
	//If the login doesnt fail
	if ( ![loginSuccess isEqualToString:@"FALSE"] )
	{
		
		cPlayerSingleton *player = [cPlayerSingleton GetInstance];
		//Load JSON data into singleton
		NSString *jsonString = [NSString stringWithString:[request responseString]];
		//Parse the json
        NSLog(@"Login succes with %@ - %@", player._username, player._password);
		NSLog(@"Login Succesful Return Packet: %@", jsonString);
		NSDictionary *deserializedData = [[NSDictionary alloc] init];
		deserializedData = [jsonString objectFromJSONString];
		
		[self ParsePlayerJson:deserializedData];
		
		//Save succesful credentials to flat file for auto-login
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
		NSString *successfulCredentials = [NSString stringWithFormat:@"%@\n%@", player._username, player._password];
		[successfulCredentials writeToFile:myFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
		
        //Restart location updating after all data has been processed
        [player._locationMGR PollCoreLocation];
        
		if ([delegate conformsToProtocol:@protocol(AsyncUICallback)])
		{
			[delegate UICallback:TRUE errorMsg:nil];
		}
	}
	else
	{
		NSLog(@"Invalid Login Credentials");
		if ([delegate conformsToProtocol:@protocol(AsyncUICallback)])
		{
			[delegate UICallback:TRUE errorMsg:@"Invalid Login Credentials"];
		}
		
	}
	 
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)LoginDidFailed:(ASIHTTPRequest *)request {

    if ([delegate conformsToProtocol:@protocol(AsyncUICallback)])
    {
        [delegate UICallback:FALSE errorMsg:nil];
    }
}

/************************************************************
 * Purpose: Sends a POST request to web server requesting an account
 *  be registered with the given username and password
 *
 * Entry: UIView has been supplied data and requests the manager to process
 *   it
 *
 * Exit: Asynchronous request sent off
 ************************************************************/
- (void)RegisterWithUsername:(NSString *)username Password:(NSString *)password {
    
    //Get url and method strings
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"PlayerPersister", nil)];
    NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodRegister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	
    //Set request attributes
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:username forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	
	[request setDidFinishSelector:@selector(RegisterDidFinished:)];
	[request setDidFailSelector:@selector(RegisterDidFailed:)];
	[request setDelegate:self];
    
	[request startAsynchronous];
}

/************************************************************
 * Purpose: Report to the UI delegate the the server has been
 *   reached supplying the appropriate message
 *
 * Entry: Succesful connection to server, register request finished
 *
 * Exit: delegate is given errorMsg and if the server was connected
 ************************************************************/
- (void)RegisterDidFinished:(ASIHTTPRequest *)request {
	
	//Account name was not taken and has been registered for the user
	if ([[request responseString] isEqualToString:@"TRUE"])
	{
        if([delegate conformsToProtocol:@protocol(AsyncUICallback)])
            [delegate UICallback:TRUE errorMsg:@"Account Created"];
	}
	//The request account name is already in use, advise user to choose another
	else
	{
        if([delegate conformsToProtocol:@protocol(AsyncUICallback)])
            [delegate UICallback:TRUE errorMsg:@"Name Taken"];
    }
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)RegisterDidFailed:(ASIHTTPRequest *)request {
	
    if([delegate conformsToProtocol:@protocol(AsyncUICallback)])
        [delegate UICallback:FALSE errorMsg:@"Cannot Connect to SERVER"];
	
}

/************************************************************
 * Purpose: Parse the extensive json file containing player information
 *   returned from the server and save the data to the player
 *
 * Entry: Called from loginDidFinished where the json packet is recieved
 *
 * Exit: viruses and infection states saved to player
 ************************************************************/
- (void)ParsePlayerJson:(NSDictionary *)playerDict {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	NSMutableArray *viruses = [[NSMutableArray alloc] init];
	
	//Retrieve information from the deserialized json string
	NSDictionary *playerViruses = [playerDict objectForKey:@"viruses"];
	
    //Iterate through virus data 
	for ( NSDictionary * each_virus in playerViruses ) 
	{
		//Needs to retrieve more virus info
		cVirus *virus = [[cVirus alloc] init];
		virus._virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		virus._owner = player._username;
        virus._instantPoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"instant_points"]];
        virus._zonePoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"zone_points"]];
        virus._virusType = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"virus_type"]];
		
		[viruses addObject:virus];
		[virus release];
	}
	//Set playerSingleton viruses
	player._viruses = viruses;
	
	[viruses release];
	
    //Parse and set data if the user is infectedWith a virus
	NSDictionary *playerInfectedWith = [playerDict objectForKey:@"infected_with"];
	for( NSDictionary *each_virus in playerInfectedWith )
	{
		//Needs to retrieve more virus info
		cVirus *infectedWith = [[cVirus alloc] init];
		infectedWith._virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		infectedWith._owner = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"virus_owner"]];
        infectedWith._instantPoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"instant_points"]];
        infectedWith._zonePoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"zone_points"]];
        infectedWith._virusType = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"virus_type"]];
        
        //causes mutation to be nil instead of @"null" if no mutation data sent back
        if ([each_virus objectForKey:@"mutation"]) 
        {
            infectedWith._mutation = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"mutation"]];
        }
        
        
		//Set playersingleton infectedWith
		player._infectedWith = infectedWith;
        
        [infectedWith release];
	}
}

/************************************************************
 * Purpose: Send a POST to the web server requesting the user to be
 *  logged out, this sets there coordinates to the north pole, or bermuda
 *  triangle on database and nils all attributes on client
 *
 * Entry: UI requests manager after button press
 *
 * Exit: Player has been logged out and login screen is present
 ************************************************************/
- (void)Logout {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	

    //Get url and method strings
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"PlayerPersister", nil)];
    NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodLogout", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	
    //Set request attributes
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:player._username forKey:@"username"];
	
	[request setDidFinishSelector:@selector(LogoutDidFinished:)];
	[request setDidFailSelector:@selector(LogoutDidFailed:)];
	[request setDelegate:self];
    [player ResetInstance];
    
	[request startAsynchronous];
}

/************************************************************
 * Purpose: Report to the UI delegate the the server has been
 *   reached supplying the appropriate message
 *
 * Entry: Succesful connection to server, logout request finished
 *
 * Exit: delegate is given errorMsg and if the server was connected
 ************************************************************/
- (void)LogoutDidFinished:(ASIHTTPRequest *)request {
	
    if ([delegate conformsToProtocol:@protocol(AsyncUICallback)]) 
    {
        [delegate UICallback:TRUE errorMsg:@""];
    }
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)LogoutDidFailed:(ASIHTTPRequest *)request {
	
	if ([delegate conformsToProtocol:@protocol(AsyncUICallback)]) 
    {
        [delegate UICallback:TRUE errorMsg:@""];
    }
}

@end
