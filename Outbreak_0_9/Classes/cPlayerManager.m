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

//Send an asynchronous POST request to the webserver's PlayerPersister dispatcher
//sending the Login method message, Callback didFinished, and didFailed set before
//POST request
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

//If the User succesfully logged in this function will save the succesful
//login credentials and parse the json packet returned that contains
//all the players info
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
			[delegate UICallback:FALSE errorMsg:@"Invalid Login Credentials"];
		}
		
	}
	 
}

//Failed connection to web-server, tell UI delegate the connection failed
- (void)LoginDidFailed:(ASIHTTPRequest *)request {

    if ([delegate conformsToProtocol:@protocol(AsyncUICallback)])
    {
        [delegate UICallback:FALSE errorMsg:nil];
    }
}

//Send an asynchronous POST request to the webserver's PlayerPersister dispatcher
//sending the Register method message, Callback didFinished, and didFailed set before
//POST request
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

//Callback from asyncronous request if web server was reached
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

//Callback from asyncronous request ON FAILED webserver request
- (void)RegisterDidFailed:(ASIHTTPRequest *)request {
	
    if([delegate conformsToProtocol:@protocol(AsyncUICallback)])
        [delegate UICallback:FALSE errorMsg:@"Cannot Connect to SERVER"];
	
}

//Parses returned json and sets playsingleton with data retrieved
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
        //virus._mutation = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"mutation"]];
		
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
        infectedWith._mutation = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"mutation"]];
        
		//Set playersingleton infectedWith
		player._infectedWith = infectedWith;
        
        [infectedWith release];
	}
}

//Send an asynchronous POST request to the webserver's PlayerPersister dispatcher
//sending the Logout method message, Callback didFinished, and didFailed set before
//POST request
- (void)Logout {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	[player ResetInstance];
}

@end
