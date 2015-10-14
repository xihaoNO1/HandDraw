//
//  DrawView.h
//  HandDraw
//
//  Created by yeeku on 14/12/14.
//  Copyright (c) 2014年 crazyit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface DrawView : UIView
@property (nonatomic, strong) UIColor* currentColor;
@property (nonatomic, assign) ShapeType shape;
@end
