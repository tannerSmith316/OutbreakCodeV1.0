//
//  cHotspotTimer.h
//  Outbreak_0_9
//
//  Created by Tanner Smith on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cHotspotTimer : NSObject {

    NSTimer * _hotspotTimer;
    NSString *_latitude;
    NSString *_longitude;
    NSNumber *_interval;
}

@property (nonatomic, retain)NSTimer * _hotspotTimer;
@property (nonatomic, retain)NSString *_latitude;
@property (nonatomic, retain)NSString *_longitude;
@property (nonatomic, retain)NSNumber *_interval;

- (void)ResetTimer;
- (void)StopTimer;


@end
