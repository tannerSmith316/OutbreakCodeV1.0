//
//  iPlayerManagerTests.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//



#import <SenTestingKit/SenTestingKit.h>
#import "cPlayerSingleton.h"

@interface iPlayerManagerTests : SenTestCase {
	cPlayerSingleton *_player;
}
@end



@implementation iPlayerManagerTests


- (void)setUp {
	_player = [cPlayerSingleton GetInstance];
}

- (void)tearDown {
	[_player release];
}


- (void)testLoginWithUsernameAndPassword {
	
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}

- (void)testLogout {
	
	STAssertNotNil(_player, @"STUBBED TEST"); 
}




@end
