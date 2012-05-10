//
//  cVirus.m
//  Outbreak_0_5
//
//  Created by iGeek Developers on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirus.h"


@implementation cVirus
@synthesize _owner;
@synthesize _virusName;
@synthesize _zonePoints;
@synthesize _instantPoints;
@synthesize _virusType;
@synthesize _mutation;

//Copy constructor
- (cVirus *)initWithVirus:(cVirus *)aVirus {
	self = [super init];
	if(self)
	{
		self._virusName = aVirus._virusName;
		self._owner = aVirus._owner;
		self._zonePoints = aVirus._zonePoints;
		self._instantPoints = aVirus._instantPoints;
		self._virusType = aVirus._virusType;
        self._mutation = aVirus._mutation;
	}
	return self;
}

//Return formatted string containing virus stats
- (NSString *)GetStats {
    NSString *formattedStats = [NSString stringWithFormat:@"Name:%@\nType:%@\nInstant Points:%@\nZone Points:%@", _virusName, _virusType, _instantPoints, _zonePoints];
    
    return formattedStats;
                                
}

@end
