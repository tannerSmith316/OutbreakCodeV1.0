//
//  cConnectionManager.h
//  Outbreak_0_9
//
//  Created by Tanner Smith on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cPlayerManager.h"

@interface cConnectionManager : NSObject {
    
    UINavigationController *_appNavController;
    NSString *_username;
    NSString *_password;
    cPlayerManager *_playerMGR;
}

@property (nonatomic, retain)cPlayerManager *_playerMGR;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;
@property (nonatomic, retain)UINavigationController *_appNavController;

- (id)initWithNavCon:(UINavigationController *)appViewStack;

@end
