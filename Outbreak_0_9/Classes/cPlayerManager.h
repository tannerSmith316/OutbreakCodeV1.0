//
//  cPlayerManager.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cPlayerManager : NSObject {

	id delegate;
	
}

@property (nonatomic, assign) id delegate;

- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password;
- (void)Logout;
- (void)RegisterWithUsername:(NSString *)username Password:(NSString *)password;

@end
