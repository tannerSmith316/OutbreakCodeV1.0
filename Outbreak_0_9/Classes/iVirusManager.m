//
//  iVirusManager.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import "cPlayerSingleton.h"
#import "cVirus.h"
#import "cVirusManager.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@interface iVirusManagerTests : SenTestCase {
	cPlayerSingleton *_player;
	cVirus *_expectedVirus;
	cVirusManager *_virusMGR;
}

@property (nonatomic, retain)cVirusManager *_virusMGR;
@property (nonatomic, retain)cVirus *_expectedVirus;
@property (nonatomic, retain)cPlayerSingleton *_player;
@end



@implementation iVirusManagerTests

@synthesize _player;
@synthesize _expectedVirus;
@synthesize _virusMGR;


- (void)setUp {
	
	//Initialize Local test objects
	_player = [cPlayerSingleton GetInstance];
	_player._username = [NSString stringWithString:@"unittest"];
	
	self._virusMGR = [[cVirusManager alloc] init];
	
	self._expectedVirus = [[cVirus alloc] init];
	_expectedVirus._virusName = [NSString stringWithString:@"Test"];
	_expectedVirus._virusType = [NSString stringWithString:@"RNA"];
	_expectedVirus._owner = [NSString stringWithString:_player._username];
	_expectedVirus._instantPoints = [NSNumber numberWithInt:0];
	_expectedVirus._zonePoints = [NSNumber numberWithInt:0];
	
	//Initialize database test data
	NSString *urlstring = [NSString stringWithFormat:@"%@testSetup.php",_player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
	[request setDidFinishSelector:@selector(setupDidFinished:)];
	[request setDidFailSelector:@selector(setupDidFailed:)];
	[request setDelegate:self];
	

	[request startSynchronous];
	
}

- (void)tearDown {
	[_player ResetInstance];
	[_expectedVirus release];
	[_virusMGR release];
}


- (void)testCreateVirus {
	
	[self._virusMGR CreateVirus:self._expectedVirus];
	
	STAssertEquals(self._expectedVirus, [self._player._viruses objectAtIndex:0], @"Count:%d", [_player._viruses count]);
}

- (void)testCreateDoubleVirus {

	[self._virusMGR CreateVirus:self._expectedVirus];
	[self._virusMGR CreateVirus:self._expectedVirus];
	
	STAssertTrue( [self._player._viruses count] == 1, @"Virus Count:%d", [self._player._viruses count] );
}


- (void)testDeleteVirus {
	
	cVirus *deleteVirus = [[cVirus alloc] init];
	deleteVirus._virusName = [NSString stringWithString:@"test2"];
	deleteVirus._owner = self._player._username;
	
	[self._player._viruses addObject:deleteVirus];
	[self._virusMGR DeleteVirus:deleteVirus];
	
	STAssertTrue([self._player._viruses count] == 0, @"Players Virus's:%@", [[_player._viruses objectAtIndex:0] _virusName]); 
	 
}

- (void)testSelectVirus {
	
	[self._virusMGR SelectVirus:_expectedVirus];
	
	STAssertEquals(self._expectedVirus, self._player._currentVirus, @"Expected virus name:%@", self._player._currentVirus._virusName);
}


- (void)setupDidFinished:(ASIHTTPRequest *)request {
		
}

- (void)setupDidFailed:(ASIHTTPRequest *)request {

}

@end
