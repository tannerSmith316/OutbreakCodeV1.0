//
//  cHotspot.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/21/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cHotspot.h"


@implementation cHotspot
@synthesize _hotspotTimer;
@synthesize _longitude;
@synthesize _latitude;

- (id)init {
	
	if (self = [super init])
	{
		_latitude = [[NSString alloc] init];
		_longitude = [[NSString alloc] init];
		_hotspotTimer = [[NSTimer alloc] init];
	}
	return self;
}

@end
