//
//  DrawView.m
//  HandDraw
//
//  Created by yeeku on 14/12/14.
//  Copyright (c) 2014年 crazyit.org. All rights reserved.
//

#import "DrawView.h"
#import "Context.h"

@implementation DrawView{
	CGPoint _firstTouch, _prevTouch, _lastTouch;
	// 定义向内存中的图片执行绘图的CGContextRef
	CGContextRef _buffCtx;
	UIImage * _image ;
}
- (id)initWithCoder:(NSCoder*)aCoder
{
	self = [super initWithCoder:aCoder];
	if (self) {
		self.currentColor = [UIColor redColor];  // 初始化时将当前颜色设为红色
		UIGraphicsBeginImageContext(self.bounds.size);  // 创建内存中的图片
		// 获取向内存中的图片执行绘图的CGContextRef
		_buffCtx = UIGraphicsGetCurrentContext();
	}
	return self;
}
// 当用户手指开始触碰时激发该方法
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	_firstTouch = [touch locationInView:self];  // 获取触碰点坐标
	// 如果当前正在进行自由绘制，_prevTouch代表第一个触碰点
	if (self.shape == kPenShape)
	{
		_prevTouch = _firstTouch;
	}
}
// 当用户手指在控件上拖动时不断激发该方法
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	_lastTouch = [touch locationInView:self];  // 获取触碰点坐标
	// 如果当前正在进行自由绘制
	if (self.shape == kPenShape)
	{
		[self draw:_buffCtx];  // 向内存中的图片执行绘制
		// 取出内存中的图片，保存到_image中
		_image = UIGraphicsGetImageFromCurrentImageContext();
	}
	// 通知该控件重绘，此时会实时绘制起始点与用户手指拖动点之间的形状
	[self setNeedsDisplay];
}
// 当用户手指离开控件时激发该方法
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    _lastTouch = [touch locationInView:self]; // 获取离开触碰的点坐标
	// 向内存中的图片执行绘制，即把最终确定的图形绘制到内存中的图片上
	[self draw:_buffCtx];
	_image = UIGraphicsGetImageFromCurrentImageContext();
	[self setNeedsDisplay];  // 通知重绘
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();  // 获取绘图上下文
	[_image drawAtPoint:CGPointZero];  // 将内存中的图片绘制出来
	[self draw:ctx];  // 调用draw:方法执行绘制
}
// 定义一个函数，用于根据_firstTouch、_lastTouch来确定矩形区域
- (CGRect) curRect
{
	return CGRectMake(_firstTouch.x, _firstTouch.y,
		_lastTouch.x - _firstTouch.x ,
		_lastTouch.y - _firstTouch.y);
}
- (void)draw:(CGContextRef)ctx
{
	// 设置线条颜色
	CGContextSetStrokeColorWithColor(ctx, self.currentColor.CGColor);
	CGContextSetFillColorWithColor(ctx, self.currentColor.CGColor);  // 设置填充颜色
	CGContextSetLineWidth(ctx, 2.0);  // 设置线宽
	CGContextSetShouldAntialias(ctx, YES);
	CGFloat leftTopX , leftTopY;
	switch (self.shape) {
		case kLineShape:
			// 添加从_firstTouch到_lastTouch的路径
			CGContextMoveToPoint(ctx, _firstTouch.x, _firstTouch.y);
			CGContextAddLineToPoint(ctx, _lastTouch.x, _lastTouch.y);
			CGContextStrokePath(ctx);  // 绘制路径
			break;
		case kRectShape:
			CGContextFillRect(ctx ,[self curRect]);  // 填充矩形
			break;
		case kEllipseShape:
			CGContextFillEllipseInRect(ctx ,[self curRect]);  // 填充椭圆
			break;
		case kRoundRectShape:
			// 计算左上角的坐标
			leftTopX = _firstTouch.x < _lastTouch.x ? _firstTouch.x : _lastTouch.x;
			leftTopY = _firstTouch.y < _lastTouch.y ? _firstTouch.y : _lastTouch.y;
			// 添加圆角矩形的路径
			CGContextAddRoundRect(ctx ,leftTopX ,leftTopY ,
				fabs(_lastTouch.x - _firstTouch.x), fabs(_lastTouch.y - _firstTouch.y), 16);
			CGContextFillPath(ctx);  // 填充路径
			break;
		case kPenShape:
			// 添加从_prevTouch到_lastTouch的路径
			CGContextMoveToPoint(ctx, _prevTouch.x, _prevTouch.y);
			CGContextAddLineToPoint(ctx, _lastTouch.x, _lastTouch.y);
			CGContextStrokePath(ctx);  // 绘制路径
			_prevTouch = _lastTouch;  // 使用_prevTouch保存当前点
			break;
	}
}
@end
