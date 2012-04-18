//
//  cVirusManager.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/18/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirusManager.h"
#import "cPlayerSingleton.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

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


- (void)CreateVirus:(cVirus *)aVirus {
	
	self._virus = aVirus;
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if ([player doesOwnVirus:aVirus])
	{
		/*
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Creation Error!" message:[NSString stringWithFormat:@"No duplicate virus names"] delegate:nil cancelButtonTitle:@"Aww!" otherButtonTitles:nil] autorelease];
		[alert show];
		[delegate UpdateCallBack:FALSE];
		 */
		 
	}
	else
	{
		NSString *urlstring = [NSString stringWithFormat:@"%@createVirus.php",player._serverIP];
		NSURL *url = [NSURL URLWithString:urlstring];
		
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
		[request setPostValue:player._username forKey:@"username"];
		[request setPostValue:aVirus._virusName forKey:@"virus_name"];
		[request setPostValue:aVirus._instantPoints forKey:@"instant_points"];
		[request setPostValue:aVirus._zonePoints forKey:@"zone_points"];
		[request setPostValue:aVirus._virusType forKey:@"virus_type"];
		
		[request setDidFinishSelector:@selector(CreationDidFinished:)];
		[request setDidFailSelector:@selector(CreationDidFailed:)];
		[request setDelegate:self];
		
		//SET TO SYNCHRONOUS WHEN TESTING
		[request startSynchronous];
		//[request startAsynchronous];
		NSLog(@"Post: Virus Creation");
	}

	
}


//TODO: request needs to return json virus that was created so MGR doesn't store locally
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
	
	
	if (delegate != nil)
	{
		[delegate UpdateCallBack:TRUE];
	}
	
}

- (void)CreationDidFailed:(ASIHTTPRequest *)request {
	
	[delegate UpdateCallBack:FALSE];
}

- (void)DeleteVirus:(cVirus *)aVirus {

	self._virus = aVirus;
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	NSString *urlstring = [NSString stringWithFormat:@"%@deleteVirus.php",player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:player._username forKey:@"username"];
	[request setPostValue:aVirus._virusName forKey:@"virus_name"];
	
	
	[request setDidFinishSelector:@selector(DeleteVirusDidFinished:)];
	[request setDidFailSelector:@selector(DeleteVirusDidFailed:)];
	
	[request setDelegate:self];
	
	//SET TO SYNCHRONOUS WHEN TESTING
	[request startSynchronous];
	//[request startAsynchronous];
	
	[aVirus release];
}


- (void)DeleteVirusDidFinished:(ASIHTTPRequest *)request {
	
	if ([[request responseString] isEqualToString:@"TRUE"])
	{
		cPlayerSingleton *player = [cPlayerSingleton GetInstance];
		
		for( cVirus *virus in player._viruses )
		{
			if ([virus._virusName isEqualToString:self._virus._virusName])
			{
				[player._viruses removeObject:virus];
				if ([player._currentVirus._virusName isEqualToString:self._virus._virusName])
				{
					player._currentVirus = nil;
					//self._currentVirusLabel.text = @"";
				}
				break;
			}
		}
		
		[delegate UpdateCallBack];
	}
	
}

- (void)DeleteVirusDidFailed:(ASIHTTPRequest *)request {
	
	//CONNECTION FAILED
	NSLog(@"Delete Error");
	[delegate CallBackDelete];
}

- (void)SelectVirus:(cVirus *)aVirus {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	player._currentVirus = aVirus;
	[delegate UpdateCallBack];
}


@end
