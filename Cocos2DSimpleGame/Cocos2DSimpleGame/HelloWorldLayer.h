//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Level.h"

typedef enum GunType : NSUInteger {
    Shotgun,
    Pistol,
    Uzi
} GunType;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    NSMutableArray * _monsters;
    NSMutableArray * _lifeUps;
    NSMutableArray * _projectiles;
    NSMutableArray * _gunBonuses;
    NSArray* _heartSprites;
    int _monstersDestroyed;
    int _monstersInLevel;
    float _lifeUpProbability;
    CCLabelTTF * _enemyCountLabel;
    CCLabelTTF * _levelLabel;
    CCLabelTTF * _livesLabel;
    CCLabelTTF * _comboLabel;
    CCLabelTTF * _pauseLabel;
    CCLabelTTF * _ammoLabel;
    CCMenuItem * _pauseMenuItem;
    CCMenuItem * _restartMenuItem;
    CCMenuItem * _godModeMenuItem;
    CCMenuItem * _nextLevelMenuItem;
    CGSize winSize;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    int _backgroundMusicVolume;
    CCAnimation * _walkAnim;
    CCSpriteBatchNode * _spriteSheet;
    bool _touching;
    NSSet* _lastTouches;
    float _reloadTime;
    float _reloadCount;
    GunType gunType;
    NSMutableDictionary *projectilesHitAnything;
}
@property Level* level;
@property int lives;
@property int comboCounter;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) monsterBreach:(CCNode*)node;
@end
