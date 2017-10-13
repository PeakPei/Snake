//
//  GameScene.m
//  Snake
//
//  Created by 何振邦 on 16/10/2.
//  Copyright (c) 2016年 何振邦. All rights reserved.
//

#import "GameScene.h"
#import "failView.h"
@implementation GameScene
static NSTimeInterval speed=0.1;
static UInt head=1<<0;
static UInt body=1<<1;
static UInt edge=1<<2;
static UInt food=1<<3;
static UInt next=1<<4;
-(void)makeFood{
    float rate=(float)(1+arc4random()%99)/100;
    CGPoint position=CGPointMake(self.frame.size.width*rate, self.frame.size.height*rate);
    SKSpriteNode* foodNode=[SKSpriteNode spriteNodeWithImageNamed:@"food"];
    foodNode.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:16];
    foodNode.physicsBody.categoryBitMask=food;
    foodNode.physicsBody.contactTestBitMask=head|body;
    foodNode.physicsBody.collisionBitMask=head|body;
    foodNode.position=position;
    [self addChild:foodNode];
    
}
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.physicsWorld.contactDelegate=self;
    self.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask=edge;
    self.physicsBody.contactTestBitMask=head|body;
    self.physicsBody.collisionBitMask=head|body;
    self.physicsWorld.gravity=CGVectorMake(0, 0);
    lastTime=-1;
    snake=[[NSMutableArray alloc]init];
    velocity=CGVectorMake(32, 0);
    score=0;
    SKSpriteNode* a;
    for (int i=0; i<4; i++) {
        a=[SKSpriteNode spriteNodeWithImageNamed:@"node"];
        a.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:16];
        a.physicsBody.categoryBitMask=body;
        a.physicsBody.contactTestBitMask=head|food|edge|body;
        a.physicsBody.collisionBitMask=head|food|edge|body|next;
        a.position=CGPointMake(self.frame.size.width/2-i*32, self.frame.size.height/2);
        [snake addObject:a];
        [self addChild:a];
    }
    ((SKSpriteNode*)[snake firstObject]).physicsBody.categoryBitMask=head;
    ((SKSpriteNode*)[snake objectAtIndex:1]).physicsBody.categoryBitMask=next;
    [self makeFood];
    //添加分数标签
    scoreLabel=[SKLabelNode labelNodeWithText:@"分数:0"];
    scoreLabel.position=CGPointMake(self.frame.size.width/10, self.frame.size.height*11/12);
    scoreLabel.fontSize=36;
    scoreLabel.zPosition=1;
    scoreLabel.fontColor=[SKColor blackColor];
    [self addChild:scoreLabel];
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    
}
-(void)keyDown:(NSEvent *)theEvent{
    switch (theEvent.keyCode) {
        case 123:
            velocity=CGVectorMake(-32, 0);
            return;
        case 124:
            velocity=CGVectorMake(32, 0);
            return;
        case 126:
            velocity=CGVectorMake(0, 32);
            return;
        case 125:
            velocity=CGVectorMake(0, -32);
            return;
        default:
            break;
    }
    //增加新的蛇节点
    SKSpriteNode* node=[SKSpriteNode spriteNodeWithImageNamed:@"node"];
    CGPoint location=((SKSpriteNode*)[snake lastObject]).position;
    node.position=location;
    node.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:16];
    node.physicsBody.categoryBitMask=body;
    node.physicsBody.contactTestBitMask=head|food|edge|body;
    node.physicsBody.collisionBitMask=head|food|edge|body;
    [snake addObject:node];
    [self addChild:node];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (lastTime<0) {
        lastTime=currentTime;
        return;
    }
    if ((currentTime-lastTime)>speed) {
        SKSpriteNode* temp;
        for (int i=[snake count]-1; i>=0; --i) {
                temp=[snake objectAtIndex:i];
            if (i==0) {
                [temp runAction:[SKAction moveBy:velocity duration:speed]];
                //temp.position=CGPointMake(temp.position.x+velocity.dx, temp.position.y+velocity.dy);
            }else{
                //temp.position=((SKSpriteNode*)[snake objectAtIndex:i-1]).position;
                [temp runAction:[SKAction moveTo:((SKSpriteNode*)[snake objectAtIndex:i-1]).position duration:speed]];
            }
        }
        lastTime=currentTime;
    }
    
}
-(void)didBeginContact:(SKPhysicsContact *)contact{
    UInt testCode=(contact.bodyA.categoryBitMask|contact.bodyB.categoryBitMask);
    if (testCode==(head|body)||testCode==(head|edge)) {
        NSLog(@"contact with edge or body");//头与身体或墙壁相碰
        
        failView* failed=[[failView alloc]initWithSize:self.frame.size];
        [failed setScore:score];
        [self.view presentScene:failed];
        
        
    }else if(testCode==(head|food)){
        score+=10;
        scoreLabel.text=[NSString stringWithFormat:@"分数:%d",score];
        SKSpriteNode* node=[SKSpriteNode spriteNodeWithImageNamed:@"node"];
        CGPoint location=((SKSpriteNode*)[snake lastObject]).position;
        node.position=location;
        node.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:16];
        node.physicsBody.categoryBitMask=body;
        node.physicsBody.contactTestBitMask=head|food|edge|body;
        node.physicsBody.collisionBitMask=head|food|edge|body;
        [snake addObject:node];
        [self addChild:node];
        NSLog(@"contact with food");//头与身体或墙壁相碰
        if (contact.bodyA.categoryBitMask==food) {
            [contact.bodyA.node removeFromParent];
        }else [contact.bodyB.node removeFromParent];
        [self makeFood];
    }
}
@end
