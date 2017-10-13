//
//  failView.m
//  Snake
//
//  Created by 何振邦 on 16/10/2.
//  Copyright © 2016年 何振邦. All rights reserved.
//

#import "failView.h"
#import "GameScene.h"
@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end
@implementation failView
@synthesize score;

-(void)didMoveToView:(SKView *)view{
    NSLog(@"%d",score);
    NSString* scoreText=[NSString stringWithFormat:@"你失败了，你的分数为:%d",score];
    SKLabelNode* note=[SKLabelNode labelNodeWithText:scoreText];
    note.position=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    note.fontSize=50;
    note.fontColor=[SKColor whiteColor];
    [self addChild:note];

    
    [self runAction:[SKAction sequence:@[
                         [SKAction waitForDuration:3.0],
                         [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        [self.view presentScene:scene transition: reveal];
    }]
        ]]];
    
}
@end
