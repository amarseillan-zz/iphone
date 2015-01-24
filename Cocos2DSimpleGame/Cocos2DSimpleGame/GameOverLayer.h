//
//  GameOverLayer.h
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright 2012 Razeware LLC. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor
{
    CCLayerColor* _callerLayer;
}

+(CCScene *) sceneWithWon:(BOOL)won caller:(CCLayerColor*)caller;
- (id)initWithWon:(BOOL)won caller:(CCLayerColor*)callerLayer;

@end
