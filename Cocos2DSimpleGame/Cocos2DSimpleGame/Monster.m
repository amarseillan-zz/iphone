//
//  Monster.m
//  Cocos2DSimpleGame
//
//  Created by AdminMacLC02 on 10/3/13.
//  Copyright 2013 Razeware LLC. All rights reserved.
//

#import "Monster.h"
#import "HelloWorldLayer.h"

@implementation Monster

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithFile:file])) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
        
        // Determine speed of the monster
        int minDuration = self.minMoveDuration; //2.0;
        int maxDuration = self.maxMoveDuration; //4.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float distance = winSize.width + self.contentSize.width;
        self.speed = distance / (float)actualDuration;
    }
    
    [self schedule:@selector(update:)];
    return self;
}

- (id)initWithSpriteFrameName:(NSString *)frame hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration {
    if ((self = [super initWithSpriteFrameName:frame])) {
        self.hp = hp;
        self.minMoveDuration = minMoveDuration;
        self.maxMoveDuration = maxMoveDuration;
        
        // Determine speed of the monster
        int minDuration = self.minMoveDuration; //2.0;
        int maxDuration = self.maxMoveDuration; //4.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float distance = winSize.width + self.contentSize.width;
        self.speed = distance / (float)actualDuration;
    }
    
    [self schedule:@selector(update:)];
    return self;
}

- (void)update:(ccTime)delta {
    
    self.position = ccp(self.position.x - delta*_speed, self.position.y);
    
    if(self.position.x < 0) {
        if ([parent_ isKindOfClass:[HelloWorldLayer class]])
            [(HelloWorldLayer*)parent_ monsterBreach:self];
        else
            [(HelloWorldLayer*)parent_.parent monsterBreach:self];
    }
}
@end

@implementation WeakAndFastMonster

- (id)init {
    if ((self = [super initWithFile:@"monster.png" hp:1 minMoveDuration:3 maxMoveDuration:5])) {
    }
    return self;
}

@end

@implementation StrongAndSlowMonster

- (id)init {
    if ((self = [super initWithFile:@"monster2.png" hp:3 minMoveDuration:6 maxMoveDuration:12])) {
    }
    return self;
}

@end

@implementation StrongAndStupidMonster

- (id)init {
    if ((self = [super initWithSpriteFrameName:@"demon1.png" hp:3 minMoveDuration:6 maxMoveDuration:12])) {
        scaleX_ = 68 / contentSize_.width;
        scaleY_ = 50 / contentSize_.height;
    }
    return self;
}

@end