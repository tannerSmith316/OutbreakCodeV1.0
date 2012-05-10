//
//  cDefaultStringTable.h
//  Outbreak_0_9
//
//  Created by Sean Velkin on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cDefaultStringTable : NSObject {
    NSString *_URLServer;
    //Sorted by: php dispatcher url followed
    //by messages that can be passed to dispatcher
    NSString *_URLPlayerPersister;
    NSString *_mLogin;
    NSString *_mLogout;
    NSString *_mRegister;
    
    NSString *_URLVirusPersister;
    NSString *_mCreate;
    NSString *_mDelete;
    
    NSString *_URLInfectionPersister;
    NSString *_mInfectPlayer;
    NSString *_mLayHotSpot;
    
    NSString *_URLLocationPersister;
    NSString *_mGetNearby;
    NSString *_mPersistLocation;
}

//@property (nonatomic, retain)

@end
