//
//  UIAsyncDelegate.h
//  Outbreak_0_9
//
//  Created by Sean Velkin on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIAsyncDelegate <NSObject>
@required
- (void)UpdateVictimTable:(NSArray *)victimArray;
@end