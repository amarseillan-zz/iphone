//
//  Level.m
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 10/3/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum enemiesNum:(int)enemiesNum secsPerSpawn:(float)secsPerSpawn backgroundColor:(ccColor4B)backgroundColor{
    if ((self = [super init])) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.backgroundColor = backgroundColor;
        self.enemiesNum = enemiesNum;
    }
    return self;
}

-(CCParticleSystem*) getParticleSystem {
    
    CGSize _winSize = [CCDirector sharedDirector].winSize;
    if(_levelNum == 1) {
        CCParticleRain *rain = [[CCParticleRain alloc] initWithTotalParticles:500];
        [rain setTexture:[[CCTextureCache sharedTextureCache] addImage:@"water_drop-icon.gif"]];
        rain.life += 1;
        rain.position = ccp(_winSize.width/2, _winSize.height);
        [rain setBlendAdditive:NO];
        return rain;
    } else if (_levelNum == 7) {
        CCParticleSnow *snow = [[CCParticleSnow alloc] initWithTotalParticles:500];
        [snow setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Snowflake-white.png"]];
        snow.position = ccp(_winSize.width/2, _winSize.height);
        [snow setBlendAdditive:NO];
        return snow;
    }
    return nil;
}

@end