//
//  cPlayerSingleton.h
//  Outbreak_0_5
//
//  Created by iGeek Developers on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cVirus.h"
#import "cLocationManager.h"
#import "cInfectionManager.h"
#import "Outbreak_0_9AppDelegate.h"

//This is a player singleton class that holds data needed App wide
@interface cPlayerSingleton : NSObject {
    Outbreak_0_9AppDelegate *appDel;

    //login username
	NSString *_username;
	//login password
	NSString *_password;
	
	//This array hols each of the users self created viruses
	NSMutableArray *_viruses;
	
	//This may be a virus that the user has contracted
	cVirus *_infectedWith;
	
	//This is the virus the player is currently playing with
	cVirus *_currentVirus;
	
	//These variables hold the players GPS coordinates
	NSString *_latitude;
	NSString *_longitude;
	
	//this variable holds the server ip adress
	NSString *_serverIP;
	
	NSTimer *_updateLocationTimer;
	
    //Managers for handling logical computations
	cLocationManager *_locationMGR;
	cInfectionManager *_infectionMGR;
}

@property (nonatomic, retain)Outbreak_0_9AppDelegate *_appDel;
@property (nonatomic, retain)NSMutableArray *_viruses;
@property (nonatomic, retain)cVirus *_infectedWith;
@property (nonatomic, retain)cVirus *_currentVirus;
@property (nonatomic, retain)NSString *_latitude;
@property (nonatomic, retain)NSString *_longitude;
@property (nonatomic, retain)NSString *_serverIP;
@property (nonatomic, retain)NSTimer *_updateLocationTimer;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;
@property (nonatomic, retain)cLocationManager *_locationMGR;
@property (nonatomic, retain)cInfectionManager *_infectionMGR;

//Public accesor for singleton class
+ (cPlayerSingleton *)GetInstance;
//Starts the timer for updating the users location
- (void)StartUpdateTimer;
//Empties all of player attributes
- (void)ResetInstance;
//Checks the virus passed in against virus's in the players virus array
- (BOOL)doesOwnVirus:(cVirus *)aVirus;

@end
