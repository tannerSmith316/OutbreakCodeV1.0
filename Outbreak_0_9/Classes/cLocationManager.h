//
//  cLocationManager.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/5/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocationController.h"

@protocol UILocationAsyncDelegate
@required
- (void)UpdateVictimTable:(NSArray *)victimArray;
@end

@interface cLocationManager : NSObject<CoreLocationControllerDelegate> {

	CoreLocationController *CLController;
	
	//Used primarily for infect screen table refresh after 
	//Loc manager retrieves victims with getNearby
	id delegate;
}

@property (nonatomic, retain)CoreLocationController *CLController;
@property (nonatomic, retain)id delegate;

//starts the core location train, is called when updatelocation timer fires
- (void)PollCoreLocation;

//Sends a POST request to get nearby players for infection attempts
- (void)GetNearby;
- (void)PersistLatitude:(NSString *)latitude andLongitude:(NSString *)longitude;

//Internal parsing function to deal with json packet returned form  update location
- (void)ParseLocationUpdateJson:(NSDictionary *)jsonDict;

@end
