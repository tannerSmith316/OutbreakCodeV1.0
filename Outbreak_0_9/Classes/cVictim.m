//
//  cVictim.m
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/20/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVictim.h"


@implementation cVictim
@synthesize _username;
@synthesize _distance;

- (cVictim *)initWithVictim:(cVictim *)aVictim {
	if(self)
	{
		self._username = aVictim._username;
		self._distance = aVictim._distance;
	}
	return self;
}

@end
