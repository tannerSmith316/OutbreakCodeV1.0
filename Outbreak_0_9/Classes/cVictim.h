//
//  cVictim.h
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/20/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cVictim : NSObject {

	NSString *_username;
	NSString *_distance;
}

- (cVictim *)initWithVictim:(cVictim *)aVictim;

@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_distance;

@end
