//
//  cHotspot.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 4/21/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cHotspot : NSObject {
	
	NSString *_latitude;
	NSString *_longitude;
	NSTimer	*_hotspotTimer;

}

@property (nonatomic, retain) NSString *_latitude;
@property (nonatomic, retain) NSString *_longitude;
@property (nonatomic, retain) NSTimer *_hotspotTimer;

@end
