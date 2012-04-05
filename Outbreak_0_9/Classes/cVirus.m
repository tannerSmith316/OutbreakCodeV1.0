//
//  cVirus.m
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirus.h"


@implementation cVirus

@synthesize _owner;
@synthesize _virusName;
@synthesize _zonePoints;
@synthesize _instantPoints;
@synthesize _virusType;

- (cVirus *)initWithVirus:(cVirus *)aVirus {
	
	if(self)
	{
		self._virusName = aVirus._virusName;
		self._owner = aVirus._owner;
		self._zonePoints = aVirus._zonePoints;
		self._instantPoints = aVirus._instantPoints;
		self._virusType = aVirus._virusType;
	}
	return self;
}

@end
