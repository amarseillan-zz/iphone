//
//  Level.h
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 10/3/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNum;
@property (nonatomic, assign) int enemiesNum;
@property (nonatomic, assign) float secsPerSpawn;
@property (nonatomic, assign) ccColor4B backgroundColor;

- (id)initWithLevelNum:(int)levelNum enemiesNum:(int)enemiesNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor;

-(CCParticleSystem*) getParticleSystem;
@end

