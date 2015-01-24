//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"
#import "LevelManager.h"
#import "Monster.h"
#import "Level.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    HelloWorldLayer *layer = [HelloWorldLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

- (void) addMonster {
    
    //CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    Monster* monster = [self createMonsterWithParent:self];

    // Determine where to spawn the monster along the Y axis
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    
    monster.tag = 1;
    [_monsters addObject:monster];
}

-(void)monsterBreach:(CCNode *)node {
    [_monsters removeObject:node];
    [node removeFromParentAndCleanup:YES];
    
    if ([LevelManager sharedManager].godMode)  return;
    _lives--;
    if (_lives < 0) {
        [self nextSceneWithWon:NO];
    } else {
        [_heartSprites[_lives] setTexture:[[CCSprite spriteWithFile:@"heartempty.png"] texture]];
        [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
    }
}

- (Monster*) createMonsterWithParent:(CCLayerColor*) parent {
    Monster * monster = nil;
    if (arc4random() % 100 < 50) {
        monster = [[WeakAndFastMonster alloc] init];
        [self addChild:monster];
    } else if (arc4random() % 100 < 80) {
        monster = [[StrongAndSlowMonster alloc] init];
        [self addChild:monster];
    } else {
        monster = [[StrongAndStupidMonster alloc] init];
        CCAction *walkAction = [CCRepeatForever actionWithAction:
                                [CCAnimate actionWithAnimation:_walkAnim]];
        [monster runAction:walkAction];
        [_spriteSheet addChild:monster];
    }
    return monster;
}


- (void) addLifeBonus {

    CCSprite * lifeUp = [CCSprite spriteWithFile:@"heart.png"];
    
    // Determine where to spawn the lifeup along the Y axis
    int minY = lifeUp.contentSize.height / 2;
    int maxY = winSize.height - lifeUp.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the lifeup sprite slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    lifeUp.position = ccp(winSize.width + lifeUp.contentSize.width/2, actualY);
    [self addChild:lifeUp];
    
    // Determine speed of the life bonus
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-lifeUp.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_lifeUps removeObject:node];
        [node removeFromParentAndCleanup:YES];
    }];
    [lifeUp runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    lifeUp.tag = 2;
    [_lifeUps addObject:lifeUp];
    
}

- (void)addGunBonus {
    
    CCSprite * gunBonus = [CCSprite spriteWithFile:@"shotgun.png"];
    
    gunBonus.scale = 0.10f;
    // Determine where to spawn the lifeup along the Y axis
    int minY = gunBonus.contentSize.height / 2;
    int maxY = winSize.height - gunBonus.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the lifeup sprite slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    gunBonus.position = ccp(winSize.width + gunBonus.contentSize.width/2, actualY);
    [self addChild:gunBonus];
    
    // Determine speed of the life bonus
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-gunBonus.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_gunBonuses removeObject:node];
        [node removeFromParentAndCleanup:YES];
    }];
    [gunBonus runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    gunBonus.tag = 2;
    [_gunBonuses addObject:gunBonus];
    
}
-(void)gameLogic:(ccTime)dt {
    [self addMonster];
    [self addGunBonus];
    float secsPerSpawn = [LevelManager sharedManager].curLevel.secsPerSpawn;
    float random = arc4random_uniform(100*secsPerSpawn)/(100.0*secsPerSpawn);
    if (random < _lifeUpProbability) {
        [self addLifeBonus];
    }
}
 
- (id) init
{
    if ((self = [super initWithColor:[LevelManager sharedManager].curLevel.backgroundColor])) {

        winSize = [CCDirector sharedDirector].winSize;
        _player = [CCSprite spriteWithFile:@"player.png"];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
        
        _reloadTime = 0.2f;
        
        [self schedule:@selector(gameLogic:) interval:[LevelManager sharedManager].curLevel.secsPerSpawn];
        [self setTouchEnabled:YES];
                
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        _lifeUps = [[NSMutableArray alloc] init];
        _gunBonuses = [[NSMutableArray alloc] init];
        
        _lifeUpProbability = 0.1;
        _comboCounter = [LevelManager sharedManager].comboCounter;
        _lives = [LevelManager sharedManager].lives;
        _level = [[LevelManager sharedManager] curLevel];
        _monstersInLevel = _level.enemiesNum;

        NSString* enemyCountMessage = [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel];
        [self showLabel:_enemyCountLabel at:ccp(winSize.width/2, winSize.height/2) withMessage:enemyCountMessage fontSize:28];
        
        NSString* levelMessage = [NSString stringWithFormat: @"Level %d", _level.levelNum];
        _levelLabel = [CCLabelTTF labelWithString:levelMessage fontName:@"Arial" fontSize:28];
        _levelLabel.color = ccc3(0,0,0);
        _levelLabel.position = ccp(winSize.width - _levelLabel.contentSize.width, winSize.height - _levelLabel.contentSize.height/2);
        [self addChild:_levelLabel];
        
        NSString* livesMessage = [NSString stringWithFormat: @"Lives %d", _level.levelNum];
        _livesLabel = [CCLabelTTF labelWithString:livesMessage fontName:@"Arial" fontSize:28];
        _livesLabel.color = ccc3(0,0,0);
        _livesLabel.position = ccp(winSize.width/2 + _livesLabel.contentSize.width/2, winSize.height - _livesLabel.contentSize.height/2);
        [self addChild:_livesLabel];
        
        
        // Standard method to create a button
        _pauseMenuItem = [CCMenuItemImage
                                    itemWithNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                    target:self selector:@selector(pauseButtonTapped:)];
        _pauseMenuItem.scale = 0.5;
        _pauseMenuItem.position = ccp(winSize.width-_pauseMenuItem.boundingBox.size.width/2, _pauseMenuItem.boundingBox.size.height/2);

        _nextLevelMenuItem = [CCMenuItemImage
                         itemWithNormalImage:@"ButtonPlus.png" selectedImage:@"ButtonPlusSel.png"
                         target:self selector:@selector(nextLevel:)];
        _nextLevelMenuItem.scale = 0.5;
        _nextLevelMenuItem.position = ccp(winSize.width-_nextLevelMenuItem.boundingBox.size.width/2, _nextLevelMenuItem.boundingBox.size.height/2 + _pauseMenuItem.boundingBox.size.height);

        _restartMenuItem = [CCMenuItemImage
                          itemWithNormalImage:@"Button1.png" selectedImage:@"Button1Sel.png"
                          target:self selector:@selector(restartLevel:)];
        _restartMenuItem.scale = 0.5;
        _restartMenuItem.position = ccp(winSize.width-_restartMenuItem.boundingBox.size.width*2, _restartMenuItem.boundingBox.size.height/2 + _pauseMenuItem.boundingBox.size.height);
        
        _godModeMenuItem = [CCMenuItemImage
                            itemWithNormalImage:@"Button2.png" selectedImage:@"Button2Sel.png"
                            target:self selector:@selector(godMode:)];
        _godModeMenuItem.scale = 0.5;
        _godModeMenuItem.position = ccp(winSize.width-_godModeMenuItem.boundingBox.size.width*3, _godModeMenuItem.boundingBox.size.height/2 + _pauseMenuItem.boundingBox.size.height);
        
        CCMenu *starMenu = [CCMenu menuWithItems:_pauseMenuItem, _nextLevelMenuItem, _godModeMenuItem, _restartMenuItem, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        NSString* pauseMenuMessage = [NSString stringWithFormat: @"Pause"];
        _pauseLabel = [CCLabelTTF labelWithString:pauseMenuMessage fontName:@"Arial" fontSize:28];
        _pauseLabel.color = ccc3(0,0,0);
        _pauseLabel.position = ccp(winSize.width - _pauseMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2);
        [self addChild:_pauseLabel];
        
        CCParticleSystem* p = [_level getParticleSystem];
        if (p) {
            if(p.parent) {
                p.parent = nil;
            }
            [self addChild:p];
        }

        NSString* comboMessage = [NSString stringWithFormat: @"Combo: x%d", _comboCounter];
        _comboLabel = [CCLabelTTF labelWithString:comboMessage fontName:@"Arial" fontSize:12];
        _comboLabel.color = ccc3(0,0,0);
        _comboLabel.position = ccp(winSize.width/2 + _comboLabel.contentSize.width, winSize.height - _comboLabel.contentSize.height*2);
        [self addChild:_comboLabel];
        
        _heartSprites = [NSArray arrayWithObjects:[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"], nil];
        int i = 1;
        for (CCSprite* heartSprite in _heartSprites) {
            if (i - 1 >= _lives) {
                [heartSprite setTexture:[[CCSprite spriteWithFile:@"heartempty.png"] texture]];
            }
            heartSprite.position = ccp(winSize.width/2  - heartSprite.contentSize.width*i++, winSize.height - heartSprite.contentSize.height/2);
            [self addChild:heartSprite];
        }
        
        [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
        
        NSString* ammoMessage = [NSString stringWithFormat: @"Ammo: %d", [LevelManager sharedManager].ammo];
        _ammoLabel = [CCLabelTTF labelWithString:ammoMessage fontName:@"Arial" fontSize:12];
        _ammoLabel.color = ccc3(0,0,0);
        _ammoLabel.position = ccp(winSize.width/2 - _ammoLabel.contentSize.width, winSize.height - _ammoLabel.contentSize.height*2);
        [self addChild:_ammoLabel];
        if ([LevelManager sharedManager].ammo <= 0) {
            _ammoLabel.visible = false;
        }
        
        [self schedule:@selector(update:)];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"demonAnim.plist"];
        _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"demonAnim.png"];
        [self addChild:_spriteSheet];
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i=1; i<=6; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"demon%d.png",i]]];
        }
        
        _walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        _backgroundMusicVolume = [SimpleAudioEngine sharedEngine].backgroundMusicVolume;
        
        gunType = Pistol;
    }
    return self;
}

-(void)showLabel:(CCLabelTTF*)label at:(CGPoint)point withMessage:(NSString*)message fontSize:(int)fontSize {
    label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:28];
    label.color = ccc3(0,0,0);
    label.position = point;
    [self addChild:label];
}

- (void)unpauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Pause"];
    [_pauseLabel setPosition:ccp(winSize.width - _pauseMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2)];
    [CCDirector sharedDirector].scheduler.timeScale = 1;
    [_pauseMenuItem setTarget:self selector:@selector(pauseButtonTapped:)];
}


- (void)pauseButtonTapped:(id)sender {
    [_pauseLabel setString:@"Resume"];
    [_pauseLabel setPosition:ccp(winSize.width - _pauseMenuItem.boundingBox.size.width - _pauseLabel.contentSize.width/2, _pauseLabel.contentSize.height/2)];
    [CCDirector sharedDirector].scheduler.timeScale = 0;
    [_pauseMenuItem setTarget:self selector:@selector(unpauseButtonTapped:)];
}

- (void) restartLevel:(id)sender {
    CCScene *gameOverScene = [HelloWorldLayer scene];
    [CCDirector sharedDirector].scheduler.timeScale = 1;
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

- (void) godMode:(id)sender {
    [LevelManager sharedManager].godMode = ![LevelManager sharedManager].godMode;
}

- (void)nextLevel:(id)sender {
    [self nextSceneWithWon:YES];
}

- (void)nextSceneWithWon:(bool)won {
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won caller:self];
    [CCDirector sharedDirector].scheduler.timeScale = 1;
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _touching = true;
    _lastTouches = touches;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    _lastTouches = touches;
    _touching = true;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _touching = false;
}

- (void)handleShot {
    if (_nextProjectile != nil) return;
    
    if ([LevelManager sharedManager].ammo  <= 0) {
        gunType = Pistol;
    }
    
    // Choose one of the touches to work with
    UITouch *touch = [_lastTouches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    _nextProjectile = [CCSprite spriteWithFile:@"projectile.png" rect:CGRectMake(0, 0, 20, 20)];
    _nextProjectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, _nextProjectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) {
        _nextProjectile = nil;
        return;
    }
    
    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + _nextProjectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    CGPoint realDest2;
    CGPoint realDest3;
    CCSprite* secondProjectile;
    CCSprite* thirdProjectile;
    if (gunType == Shotgun) {
         realDest2 = ccpRotateByAngle(realDest, _nextProjectile.position, tan(M_PI/12));
        secondProjectile = [CCSprite spriteWithFile:@"projectile.png" rect:CGRectMake(0, 0, 20, 20)];
        secondProjectile.position = ccp(20, winSize.height/2);
    
        realDest3 = ccpRotateByAngle(realDest, _nextProjectile.position, tan(-M_PI/12));
        thirdProjectile = [CCSprite spriteWithFile:@"projectile.png" rect:CGRectMake(0, 0, 20, 20)];
        thirdProjectile.position = ccp(20, winSize.height/2);
        [[LevelManager sharedManager] reduceAmmo:3];
        if ([LevelManager sharedManager].ammo > 0) {
            _ammoLabel.visible = true;
            [_ammoLabel setString: [NSString stringWithFormat: @"Ammo: %d", [LevelManager sharedManager].ammo]];
        } else {
            _ammoLabel.visible = false;

        }
    }
    

    // Determine the length of how far you're shooting
    int offRealX = realX - _nextProjectile.position.x;
    int offRealY = realY - _nextProjectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Determine angle to face
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    float rotateDegreesPerSecond = 180 / 0.1; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
    float degreesDiff = _player.rotation - cocosAngle;
    float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
    [_player runAction:
     [CCSequence actions:
      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
      [CCCallBlock actionWithBlock:^{
         // OK to add now - rotation is finished!
         [self addChild:_nextProjectile];
         if (gunType == Shotgun && secondProjectile != nil && thirdProjectile != nil) {
             [self addChild:secondProjectile];
             [self addChild:thirdProjectile];
             [_projectiles addObject:_nextProjectile];
             [_projectiles addObject:secondProjectile];
             [_projectiles addObject:thirdProjectile];
         }
         // Release
         _nextProjectile = nil;
     }],
      nil]];
    
    // Move projectile to actual endpoint
    [_nextProjectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [_projectiles removeObject:node];
         [self resetComboCounter];
         [node removeFromParentAndCleanup:YES];
     }],
      nil]];
    
    if (gunType == Shotgun && secondProjectile != nil && thirdProjectile != nil) {

        // Move projectile to actual endpoint
        [secondProjectile runAction:
         [CCSequence actions:
          [CCMoveTo actionWithDuration:realMoveDuration position:realDest2],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [_projectiles removeObject:node];
             [self resetComboCounter];
             [node removeFromParentAndCleanup:YES];
         }],
          nil]];
        
        // Move projectile to actual endpoint
        [thirdProjectile runAction:
         [CCSequence actions:
          [CCMoveTo actionWithDuration:realMoveDuration position:realDest3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [_projectiles removeObject:node];
             [self resetComboCounter];
             [node removeFromParentAndCleanup:YES];
         }],
          nil]];
    }
    _nextProjectile.tag = 2;
    [_projectiles addObject:_nextProjectile];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}


- (void)update:(ccTime)dt {
    
    _reloadCount -= dt;
    if (_touching == true && _reloadCount < 0) {
        [self handleShot];
        _reloadCount = _reloadTime;        
    }
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        BOOL monsterHit = FALSE;
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (Monster *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                monsterHit = TRUE;
                monster.hp--;
                if (monster.hp <= 0) {
                    [monstersToDelete addObject:monster];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"3b0817_New_Super_Mario_Bros_Firework_Sound_Effect.mp3"];
                }
                break;
            }
        }
                
        for (Monster *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            if ([monster isKindOfClass:[StrongAndStupidMonster class]])
                [_spriteSheet removeChild:monster cleanup:YES];
            [self removeChild:monster cleanup:YES];
            
            _monstersDestroyed++;
            [_enemyCountLabel setString: [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _monstersInLevel]];
            _comboCounter++;
            [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];

            if (_monstersDestroyed >= _monstersInLevel) {
                [self nextSceneWithWon:YES];
            }
        }
        
        NSMutableArray *livesToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *life in _lifeUps) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, life.boundingBox)) {
                [livesToDelete addObject:life];
            }
        }
        
        for (CCSprite *life in livesToDelete) {
            [_lifeUps removeObject:life];
            [self removeChild:life cleanup:YES];
            if (_lives < 3) {
                [_heartSprites[_lives] setTexture:[[CCSprite spriteWithFile:@"heart.png"] texture]];
                _lives++;
                [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
            }
        }
        
        NSMutableArray *gunBonusesToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *gunBonus in _gunBonuses) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, gunBonus.boundingBox)) {
                [gunBonusesToDelete addObject:gunBonus];
            }
        }

        for (CCSprite *gunBonus in gunBonusesToDelete) {
            [_gunBonuses removeObject:gunBonus];
            [self removeChild:gunBonus cleanup:YES];
        }
        
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
        } else if (livesToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"3fc83f_Super_Mario_Bros_1_Up_Sound_Effect.mp3"];
        } else if (gunBonusesToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"d9271e_New_Super_Mario_Bros_Coin_Sound_Effect.mp3"];
            gunType = Shotgun;
            [[LevelManager sharedManager] loadAmmo:15];
            if ([LevelManager sharedManager].ammo > 0) {
                _ammoLabel.visible = true;
                [_ammoLabel setString: [NSString stringWithFormat: @"Ammo: %d", [LevelManager sharedManager].ammo]];
            }
        }
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
}

-(void) resetComboCounter {
    _comboCounter = 0;
    [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    _monsters = nil;
    _projectiles = nil;
    _lifeUps = nil;
    _gunBonuses = nil;
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] dismissModalViewControllerAnimated:YES];
}
@end
