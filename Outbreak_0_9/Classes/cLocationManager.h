//
//  cLocationManager.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/5/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocationController.h"


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

- (void)GetNearby;

@end
