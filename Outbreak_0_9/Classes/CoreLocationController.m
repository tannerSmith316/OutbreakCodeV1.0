
#import "CoreLocationController.h"


@implementation CoreLocationController

@synthesize locMgr, delegate;

- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease];
		self.locMgr.delegate = self;
		self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		
		//if (newLocation.horizontalAccuracy < 30.0)
		{
			/*NSLog(@"latitude %+.6f, longitude %+.6f\n",
				  newLocation.coordinate.latitude,
				  newLocation.coordinate.longitude);*/
			[manager stopUpdatingLocation];
			[self.delegate locationUpdate:newLocation];
		}
		
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

@end
