//
//  cVirusManager.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/18/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "cPlayerSingleton.h"
#import "cVirusManager.h"

@implementation cVirusManager
@synthesize _virus;
@synthesize delegate;

- (id)init {
	self = [super init];
	if (self != nil)
	{

	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

/************************************************************
 * Purpose: Checks if the player already owns the virus, if not
 *   make the POST to the web server asking for the creation
 *   of the virus passed in
 *
 * Entry: UIButton hit from virusCreationscreen
 *
 * Exit: Asynchronous POST sent or user is alerted of errors
 ************************************************************/
- (void)CreateVirus:(cVirus *)aVirus {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._virus = aVirus;
	
    //Warn the user if they already have the virus they are trying to create
	if ([player doesOwnVirus:aVirus])
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Creation Error!" message:[NSString stringWithFormat:@"No duplicate virus names"] delegate:nil cancelButtonTitle:@"Aww!" otherButtonTitles:nil] autorelease];
		[alert show];
		
        if ([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
        {
            [delegate UpdateCallback:FALSE errMsg:nil];
        }
	}
	else
	{//POST the virus to the webserver
		NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"VirusPersister", nil)];
        NSURL *url = [NSURL URLWithString:urlstring];
        NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodCreateVirus", nil)];
		
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:webMethod forKey:@"method"];
		[request setPostValue:player._username forKey:@"username"];
		[request setPostValue:aVirus._virusName forKey:@"virus_name"];
		[request setPostValue:aVirus._instantPoints forKey:@"instant_points"];
		[request setPostValue:aVirus._zonePoints forKey:@"zone_points"];
		[request setPostValue:aVirus._virusType forKey:@"virus_type"];
		
		[request setDidFinishSelector:@selector(CreationDidFinished:)];
		[request setDidFailSelector:@selector(CreationDidFailed:)];
		[request setDelegate:self];
		
		//SET TO SYNCHRONOUS WHEN TESTING
		//[request startSynchronous];
		[request startAsynchronous];
		NSLog(@"Post: Virus Creation");
	}	
}

/************************************************************
 * Purpose: If server said creation was succesful, we add the virus
 *   the the players virus array and report to the delegate that
 *   the request has finished
 *
 * Entry: succesful connection to server VirusPersister
 *
 * Exit: Delegate has been alerted
 ************************************************************/
- (void)CreationDidFinished:(ASIHTTPRequest *)request {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Virus was created succesfully
	if ([[request responseString] isEqualToString:@"TRUE"])
	{
		self._virus._owner = player._username;
		
		//Save to playersingleton array of viruses
		[player._viruses addObject:self._virus];
		
		NSLog(@"Post: Virus Creation - Succesful:Added Virus to players Array");
	}
	
	if ([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
	{
		[delegate UpdateCallback:TRUE errMsg:nil];
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
- (void)CreationDidFailed:(ASIHTTPRequest *)request {
	
	if ([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
    {
        [delegate UpdateCallback:FALSE errMsg:@"Cannot connect to server"];
    }
}

/************************************************************
 * Purpose: makes a post to the server requesting that the virus
 *   passed in be deleted form the players virus array
 *
 * Entry: User has selected a virus and pressed delete button
 *   from virus selection screen
 *
 * Exit: asynchronous POST has been sent
 ************************************************************/
- (void)DeleteVirus:(cVirus *)aVirus {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._virus = aVirus;
	
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"VirusPersister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodDeleteVirus", nil)];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:player._username forKey:@"username"];
	[request setPostValue:aVirus._virusName forKey:@"virus_name"];
	[request setDidFinishSelector:@selector(DeleteVirusDidFinished:)];
	[request setDidFailSelector:@selector(DeleteVirusDidFailed:)];
	[request setDelegate:self];
	
	//SET TO SYNCHRONOUS WHEN TESTING
	[request startAsynchronous];
	//[request startAsynchronous];
	
	[aVirus release];
}

/************************************************************
 * Purpose: If the web server sais the virus has been deleted from
 *   persistance, then we remove it from the player virus array and
 *   alert the delegate that processing is complete
 *
 * Entry: succesful connection to DeleteVirus
 *
 * Exit: delegate has been alerted
 ************************************************************/
- (void)DeleteVirusDidFinished:(ASIHTTPRequest *)request {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if ([[request responseString] isEqualToString:@"TRUE"])
	{
		for( cVirus *virus in player._viruses )
		{
			if ([virus._virusName isEqualToString:self._virus._virusName])
			{
				[player._viruses removeObject:virus];
				if ([player._currentVirus._virusName isEqualToString:self._virus._virusName])
				{
					player._currentVirus = nil;
				}
                //Once its removed, GET OUT
				break;
			}
		}
        if([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
            [delegate UpdateCallback:TRUE errMsg:nil];
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
- (void)DeleteVirusDidFailed:(ASIHTTPRequest *)request {
	
	//CONNECTION FAILED
	NSLog(@"Delete Error");
	if([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
        [delegate UpdateCallback:FALSE errMsg:@"Cannot connect to web server"];
}

/************************************************************
 * Purpose: Sets the players currentVirus to the one passed into
 *   the function
 *
 * Entry: User has selected a virus and pressed the "Select" button
 *   from the virus selectionView
 *
 * Exit: delegate is alerted of the process completeted
 ************************************************************/
- (void)SelectVirus:(cVirus *)aVirus {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	player._currentVirus = aVirus;
    [player._infectionMGR._hotspotTimer ResetTimer];
    if([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
        [delegate UpdateCallback:TRUE errMsg:nil];
}

@end
