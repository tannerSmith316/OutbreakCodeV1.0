//
//  iInfectionManagerTests.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import "cPlayerSingleton.h"

@interface iInfectionManagerTests : SenTestCase {
	cPlayerSingleton *_player;
}
@end



@implementation iInfectionManagerTests


- (void)setUp {
	_player = [cPlayerSingleton GetInstance];
}

- (void)tearDown {
	[_player release];
}


- (void)testPersistInfectionWithVictim {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testLayHotspot {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testDefendInfection {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testAttemptInstant {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}


@end
