//
//  cVictim.h
//  Outbreak_0_5
//
//  Created by iGeek Developers on 2/20/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

//holds neccasary info for passing at risk users around 
//for possible infections
@interface cVictim : NSObject {

	NSString *_username;
    //victims distance from player
	NSString *_distance;
}

- (cVictim *)initWithVictim:(cVictim *)aVictim;

@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_distance;

@end
