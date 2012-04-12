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

@interface iVirusManagerTests : SenTestCase {
	cPlayerSingleton *_player;
}
@end



@implementation iVirusManagerTests


- (void)setUp {
	_player = [cPlayerSingleton GetInstance];
}

- (void)tearDown {
	[_player release];
}


- (void)testCreateVirus {
	
	cVirus *expectedVirus = [[cVirus alloc] init];
	expectedVirus._virusName = @"Toby";
	cVirusManager *virusMGR = [[cVirusManager alloc] init];
	
	[virusMGR CreateVirus:expectedVirus];
	
	[NSThread sleepForTimeInterval:5.0];
	STAssertEquals(expectedVirus, [_player._viruses objectAtIndex:0], @"Virus:%@", [[_player._viruses objectAtIndex:0] _virusName]);
}

- (void)testDeleteVirus {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testSelectVirus {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}



@end
