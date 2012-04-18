//
//  iPlayerManagerTests.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//



#import <SenTestingKit/SenTestingKit.h>
#import "cPlayerSingleton.h"
#import "cPlayerManager.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"



@interface iPlayerManagerTests : SenTestCase {
	cPlayerSingleton *_player;
	cPlayerManager *_playerMGR;
}

@property (nonatomic, retain)cPlayerSingleton *_player;
@property (nonatomic, retain)cPlayerManager *_playerMGR;

@end



@implementation iPlayerManagerTests

@synthesize _player;
@synthesize _playerMGR;

- (void)setUp {
	self._player = [cPlayerSingleton GetInstance];
	self._playerMGR = [[cPlayerManager alloc] init];
	
	//Initialize database test data
	NSString *urlstring = [NSString stringWithFormat:@"%@testSetup.php",_player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
	[request setDidFinishSelector:@selector(setupDidFinished:)];
	[request setDidFailSelector:@selector(setupDidFailed:)];
	[request setDelegate:self];
	
	//SET TO SYNCHRONOUS WHEN TESTING
	[request startSynchronous];
}

- (void)tearDown {
	[self._player ResetInstance];
	[self._playerMGR release];
}


- (void)testLoginWithUsernameAndPassword {
	
	[self._playerMGR LoginWithUsername:@"unittest" Password:@"123"];
	
	STAssertEquals(self._player._username, @"unittest", @"Username:%@", self._player._username); 
}

- (void)testLogout {
	
	self._player._username = [NSString stringWithString:@"unittest"];
	self._player._password = [NSString stringWithString:@"123"];
	self._player._latitude = [NSNumber numberWithInt:120];
	self._player._longitude = [NSNumber numberWithInt:120];
	
	cVirus *aVirus = [[cVirus alloc] init];
	aVirus._owner = [NSString stringWithString:@"unittest"];
	aVirus._virusName = [NSString stringWithString:@"test"];
	
	cVirus *aVirus2 = [[cVirus alloc] init];
	aVirus._owner = [NSString stringWithString:@"unittest"];
	aVirus._virusName = [NSString stringWithString:@"test2"];
	
	[self._player._viruses addObject:aVirus];
	[self._player._viruses addObject:aVirus2];
	
	[self._playerMGR Logout];
	STAssertTrue([self._player._viruses count] == 0, @"Virus Count:%@", [self._player._viruses count]);
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)setupDidFinished:(ASIHTTPRequest *)request {
	
}

- (void)setupDidFailed:(ASIHTTPRequest *)request {
	
}



@end
