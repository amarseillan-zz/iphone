//
//  Monster.h
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 10/3/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Monster : CCSprite

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
@property (nonatomic, assign) float speed;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

- (id)initWithSpriteFrameName:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

@interface WeakAndFastMonster : Monster
@end

@interface StrongAndSlowMonster : Monster
@end

@interface StrongAndStupidMonster : Monster
@end
