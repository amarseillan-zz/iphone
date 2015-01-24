//
//  HelloWorldLayer.h
//  TP2
//
//  Created by AdminMacLC02 on 11/7/13.
//  Copyright bb 2013. All rights reserved.
//

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk headers
#import "chipmunk.h"

@interface HelloWorldLayer2 : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *_spriteTexture; // weak ref
	CCPhysicsDebugNode *_debugLayer; // weak ref
	
	cpSpace *_space; // strong ref
	
	cpShape *_walls[4];
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
