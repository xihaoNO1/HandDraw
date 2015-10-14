//
//  ViewController.m
//  HandDraw
//
//  Created by yeeku on 14/12/14.
//  Copyright (c) 2014年 crazyit.org. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@implementation ViewController{
	NSArray* _colors;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	// 创建、添加选择颜色的UISegmentedControl
	UISegmentedControl* colorControl = [[UISegmentedControl alloc]
										initWithItems:@[@"红", @"绿", @"蓝", @"黄", @"紫", @"青", @"黑"]];
	CGRect viewBounds = self.view.bounds;
	colorControl.frame = CGRectMake(20, 20, CGRectGetWidth(viewBounds) - 40, 29);
	colorControl.selectedSegmentIndex = 0; // 设置默认选中第一项
	[colorControl addTarget:self action:@selector(changeColor:)
		   forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:colorControl];
	// 创建绘制图形的UISegmentedControl
	UISegmentedControl* shapeControl = [[UISegmentedControl alloc]
										initWithItems:@[@"直线", @"矩形", @"椭圆", @"圆角矩形", @"铅笔"]];
	shapeControl.selectedSegmentIndex = 0; // 设置默认选中第一项
	[shapeControl addTarget:self action:@selector(changeShape:)
		   forControlEvents:UIControlEventValueChanged];
	// 创建工具条
	UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0 ,
																	 CGRectGetHeight(viewBounds) - 44 , CGRectGetWidth(viewBounds) , 44)];
	// 使用工具条包装UISegmentedControl
	toolBar.items = @[ [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
						UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
					   [[UIBarButtonItem alloc] initWithCustomView:shapeControl],
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
//    toolBar.items = @[
//                       [[UIBarButtonItem alloc] initWithCustomView:shapeControl],
//                       ];
	// 添加工具条
	[self.view addSubview:toolBar];
	_colors = @[[UIColor redColor],[UIColor greenColor],
				[UIColor blueColor],[UIColor yellowColor],
				[UIColor purpleColor],[UIColor cyanColor],
				[UIColor blackColor]];
}
- (void)changeColor:(UISegmentedControl*)sender {
	// 根据用户的选择来修改DrawView的当前颜色
	((DrawView*)self.view).currentColor = _colors[sender.selectedSegmentIndex];
}
- (void)changeShape:(UISegmentedControl*)sender
{
	// 修改DrawView控件的shape属性
	((DrawView*)self.view).shape = (int)sender.selectedSegmentIndex;
}
@end

