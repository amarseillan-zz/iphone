//
//  HudLayer.m
//  TP2
//
//  Created by AdminMacLC02 on 11/21/13.
//  Copyright (c) 2013 bb. All rights reserved.
//

#import "HudLayer.h"
#import "LevelManager.h"
#import "GameOverLayer.h"
#import "GameLayer.h"


@implementation HudLayer
{
    CCLabelTTF *_label;
    CCLabelTTF *_enemyCountLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_livesLabel;
    CCLabelTTF *_pauseLabel;
    CCLabelTTF *_comboLabel;
    CCLabelTTF *_ammoLabel;
    CCMenuItem *_pauseMenuItem;
    CCMenuItem *_nextLevelMenuItem;
    CCMenuItem *_restartMenuItem;
    CCMenuItem *_godModeMenuItem;
    NSMutableArray* _heartSprites;
    CGSize winSize;
}

- (id)init
{
    self = [super init];
    if (self) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        _level = [LevelManager sharedManager].curLevel;
        
        _label = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana-Bold" fontSize:18.0];
        _label.color = ccc3(0,0,0);
        int margin = 10;
        _label.position = ccp(winSize.width - (_label.contentSize.width/2) - margin, winSize.height - _label.contentSize.height/2 - margin);
        [self addChild:_label];
        
        CCMenuItem *on;
        CCMenuItem *off;
        
        on = [CCMenuItemImage itemWithNormalImage:@"projectile-button-on.png"
                                    selectedImage:@"projectile-button-on.png" target:nil selector:nil];
        off = [CCMenuItemImage itemWithNormalImage:@"projectile-button-off.png"
                                     selectedImage:@"projectile-button-off.png" target:nil selector:nil];
        
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self
                                                               selector:@selector(projectileButtonTapped:) items:off, on, nil];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = ccp(100, 32);
        [self addChild:toggleMenu];
        
        NSString* enemyCountMessage = [NSString stringWithFormat: @"Enemies killed %d/%d", _monstersDestroyed, _level.enemiesNum];        
        _enemyCountLabel = [CCLabelTTF labelWithString:enemyCountMessage fontName:@"Arial" fontSize:18];
        _enemyCountLabel.color = ccc3(0,0,0);
        CGPoint point = ccp(0, winSize.height);
        point.x += _enemyCountLabel.contentSize.width/2;
        point.y -= _enemyCountLabel.contentSize.height/2;
        _enemyCountLabel.position = point;
        [self addChild:_enemyCountLabel];
        
        
//        NSString* levelMessage = [NSString stringWithFormat: @"Level %d", _level.levelNum];
//        _levelLabel = [CCLabelTTF labelWithString:levelMessage fontName:@"Arial" fontSize:28];
//        _levelLabel.color = ccc3(0,0,0);
//        _levelLabel.position = ccp(winSize.width - _levelLabel.contentSize.width, winSize.height - _levelLabel.contentSize.height/2);
//        [self addChild:_levelLabel];
        
//        NSString* livesMessage = [NSString stringWithFormat: @"Lives %d", _level.levelNum];
//        _livesLabel = [CCLabelTTF labelWithString:livesMessage fontName:@"Arial" fontSize:28];
//        _livesLabel.color = ccc3(0,0,0);
//        _livesLabel.position = ccp(winSize.width/2 + _livesLabel.contentSize.width/2, winSize.height - _livesLabel.contentSize.height/2);
//        [self addChild:_livesLabel];
        
        
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
        
//        NSString* comboMessage = [NSString stringWithFormat: @"Combo: x%d", _comboCounter];
//        _comboLabel = [CCLabelTTF labelWithString:comboMessage fontName:@"Arial" fontSize:12];
//        _comboLabel.color = ccc3(0,0,0);
//        _comboLabel.position = ccp(winSize.width/2 + _comboLabel.contentSize.width, winSize.height - _comboLabel.contentSize.height*2);
//        [self addChild:_comboLabel];
//        
//        _heartSprites = [NSArray arrayWithObjects:[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"],[CCSprite spriteWithFile:@"heart.png"], nil];
//        int i = 1;
//        for (CCSprite* heartSprite in _heartSprites) {
//            if (i - 1 >= _lives) {
//                [heartSprite setTexture:[[CCSprite spriteWithFile:@"heartempty.png"] texture]];
//            }
//            heartSprite.position = ccp(winSize.width/2  - heartSprite.contentSize.width*i++, winSize.height - heartSprite.contentSize.height/2);
//            [self addChild:heartSprite];
//        }
        
//        [_livesLabel setString: [NSString stringWithFormat: @"Lives %d", _lives]];
        
//        NSString* ammoMessage = [NSString stringWithFormat: @"Ammo: inf"];
//        _ammoLabel = [CCLabelTTF labelWithString:ammoMessage fontName:@"Arial" fontSize:12];
//        _ammoLabel.color = ccc3(0,0,0);
//        _ammoLabel.position = ccp(winSize.width/2 - _ammoLabel.contentSize.width, winSize.height - _ammoLabel.contentSize.height*2);
//        [self addChild:_ammoLabel];
        
    }
    return self;
}

-(void)numCollectedChanged:(int)numCollected
{
    _label.string = [NSString stringWithFormat:@"%d",numCollected];
}

- (void)projectileButtonTapped:(id)sender
{
    if (_gameLayer.mode == 1) {
        _gameLayer.mode = 0;
    } else {
        _gameLayer.mode = 1;
    }
}

-(void)showLabel:(CCLabelTTF*)label at:(CGPoint)point withMessage:(NSString*)message fontSize:(int)fontSize {

}

-(void) resetComboCounter {
    _comboCounter = 0;
    [_comboLabel setString:[NSString stringWithFormat: @"Combo: x%d", _comboCounter]];
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
    CCScene *gameOverScene = [GameLayer scene];
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

-(void)updateEnemyCounter:(int)num {
    NSString* enemyCountMessage = [NSString stringWithFormat: @"Enemies killed %d/%d", num, _level.enemiesNum];
    _enemyCountLabel.string = enemyCountMessage;
}

@end

