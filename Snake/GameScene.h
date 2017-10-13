//
//  GameScene.h
//  Snake
//

//  Copyright (c) 2016年 何振邦. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene<SKPhysicsContactDelegate>{
    NSTimeInterval lastTime;
    NSMutableArray* snake;
    CGVector velocity;
    int score;
    SKLabelNode* scoreLabel;
}
-(void)makeFood;

@end
