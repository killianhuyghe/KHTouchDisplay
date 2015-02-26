//
//  UITouch+TouchDisplay.h
//  KHTouchDisplay
//
//  Created by Killian HUYGHE on 10/12/14.
//  Copyright (c) 2014 Killian HUYGHE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOUCH_ALPHA 0.75f
#define TOUCH_IMAGE @"blue_circle"
#define TOUCH_WIDTH 40
#define TOUCH_HEIGHT 40

@interface UITouch (KHTouchDisplay)

@property (nonatomic, retain) UIImageView *imageView;

@end
