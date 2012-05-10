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


//Callback on succesful connection to web server, if web server
//returns TRUE, save the virus into the players array.
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

//Failed connection to server, send FAIL to delegate with error msg
- (void)CreationDidFailed:(ASIHTTPRequest *)request {
	
	if ([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
    {
        [delegate UpdateCallback:FALSE errMsg:@"Cannot connect to server"];
    }
}

//This is an asynchronous POST to persist the deletion of
//the sent virus
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

//Callback on succesful connection to server, if server returns true
//Remove the saved virus info from the array of player viruses
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

//Callback indicating failed connection to server, report failure and 
//errormsg to delegate
- (void)DeleteVirusDidFailed:(ASIHTTPRequest *)request {
	
	//CONNECTION FAILED
	NSLog(@"Delete Error");
	if([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
        [delegate UpdateCallback:FALSE errMsg:@"Cannot connect to web server"];
}

//Sets the player's current virus to the one passed in and starts
//its hotspot timer, no POST here(current virus is not saved on server)
- (void)SelectVirus:(cVirus *)aVirus {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	player._currentVirus = aVirus;
    [player._infectionMGR._hotspotTimer ResetTimer];
    if([delegate conformsToProtocol:@protocol(UIVirusAsyncDelegate)])
        [delegate UpdateCallback:TRUE errMsg:nil];
}

@end
