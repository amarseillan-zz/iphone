//
//  Player.m
//  Tale
//
//  Created by AdminMacLC04 on 10/24/13.
//  Copyright (c) 2013 AdminMacLC04. All rights reserved.
//

#import "Player.h"
#import "Graph.h"
#import "GameLayer.h"

#define FRICTION 0.67f

@implementation Player

- (id)initWithLayer:(GameLayer *)layer {
    self = [super initWithFile:@"bullet.png"];
    
    if (self != nil) {
        _gameLayer = layer;
        _speed = 3000;
        _name = @"Alvanator";
        float playerMass = 10.0f;
        float playerRadius = 13.0f;
        
        self.chipmunkBody = [layer.space add:[ChipmunkBody bodyWithMass:playerMass andMoment:INFINITY]];
        ChipmunkShape *playerShape = [layer.space add:[ChipmunkCircleShape circleWithBody:self.chipmunkBody radius:playerRadius offset:cpvzero]];
        playerShape.friction = 0.1;
        playerShape.collisionType = [Player class];
        playerShape.layers = LAYER_UNITS | LAYER_TERRAIN;
        playerShape.data = self;
    }
    [self schedule:@selector(update:)];
    
    return self;
}

- (void)update:(ccTime)delta {
    [self.chipmunkBody resetForces];
    
    if (_path != nil) {
        
        Node*  nextTile = [_path objectAtIndex:0];
        
//        CCLOG(@"(%f,%f) - (%d,%d)", playerTile.x, playerTile.y, nextTile.x, nextTile.y);
        
        float x = (nextTile.x +0.5) * _gameLayer.tileMap.tileSize.width;
        float y  = (nextTile.y +0.5) * _gameLayer.tileMap.tileSize.height;
        
        CGPoint sub = ccpSub(ccp(x,y), self.position);
        if (ccpLengthSQ(sub) > 0) {
            CGPoint dir = ccpNormalize(sub);
//            self.position = ccpAdd(ccpMult(dir, _speed*delta), self.position);
            [self.chipmunkBody applyForce:ccpMult(dir, _speed * self.chipmunkBody.mass) offset:cpvzero];
        }
        
        if (ccpFuzzyEqual(self.position, ccp(x,y), 7)) {
            if ([_path count] > 0) {
                [_path removeObjectAtIndex:0];
                if ([_path count] == 0) {
                    _path = nil;
                }
            }
        }
    }

    [_gameLayer setPlayerPosition:self.position];
    [_gameLayer setViewPointCenter:self.position];
    self.chipmunkBody.vel = ccpMult(self.chipmunkBody.vel, FRICTION);
}

-(void)setPath:(NSMutableArray*)path {
    _path = path;
}

@end
