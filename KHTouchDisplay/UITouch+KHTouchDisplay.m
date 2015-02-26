//
//  UITouch+TouchDisplay.m
//  KHTouchDisplay
//
//  Created by Killian HUYGHE on 10/12/14.
//  Copyright (c) 2014 Killian HUYGHE. All rights reserved.
//

#import "UITouch+KHTouchDisplay.h"

#import <objc/runtime.h>

static char const * const ImageViewKey = "TouchKey";

void methodSwizzle(Class c, SEL origSEL, SEL overrideSEL) {
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)))
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, overrideMethod);
}

@implementation UITouch (KHTouchDisplay)
@dynamic imageView;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        methodSwizzle([self class], @selector(locationInView:), @selector(swizzledLocationInView:));
    });
}

- (UIImageView *)imageView {
    return objc_getAssociatedObject(self, ImageViewKey);
}

- (void)setImageView:(UIImageView *)imageView {
    objc_setAssociatedObject(self, ImageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)swizzledLocationInView:(UIView *)view {
    CGPoint res = [self swizzledLocationInView:view];
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TOUCH_IMAGE]];
        self.imageView.frame = CGRectMake(0, 0, TOUCH_WIDTH, TOUCH_HEIGHT);
        self.imageView.alpha = TOUCH_ALPHA;
        self.imageView.userInteractionEnabled = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self.imageView];
    }
    if (view) {
        CGPoint pos = [self swizzledLocationInView:nil];
        self.imageView.center = CGPointMake(pos.x, pos.y);
    } else if (!view) {
        self.imageView.center = CGPointMake(res.x, res.y);
    }
    
    // Force update
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{});
    
    return res;
}

- (void)dealloc {
    [self.imageView removeFromSuperview];
    self.imageView.image = nil;
    self.imageView = nil;
}

@end
