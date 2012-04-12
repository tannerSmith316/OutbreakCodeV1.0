//
//  iLocationManagerTests.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import "cPlayerSingleton.h"

@interface cLocationManagerTests : SenTestCase {
	cPlayerSingleton *_player;
}
@end



@implementation cLocationManagerTests


- (void)setUp {
	_player = [cPlayerSingleton GetInstance];
}

- (void)tearDown {
	[_player release];
}
 

- (void)testPollLocation {

	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testGetNearby {

	STAssertNotNil(_player, @"STUBBED TEST"); 
}





@end
