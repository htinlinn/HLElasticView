//
//  HLElasticScaleView.m
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLElasticScaleView.h"
#import "HLUtility.h"

@interface HLElasticScaleView ()
@property (nonatomic, assign) CGRect referenceFrame;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGRect goal;
@property (nonatomic, strong) CADisplayLink *displayLink;

- (void)updateScale;
@end

@implementation HLElasticScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2.0f;
        self.layer.masksToBounds = YES;
        self.referenceFrame = self.frame;
        self.isScaling = NO;
    }
    return self;
}


#pragma mark -

- (void)translate:(CGPoint)distance
{    
    CGFloat scaledDistance = distance.y * 1.0f;
    CGFloat scale = dampedScale(self.referenceFrame, self.frame, &scaledDistance);
    
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.center = CGPointMake(self.center.x + distance.x / 2, self.center.y + scaledDistance / 2);    
}

- (void)scale:(CGRect)goal withVelocity:(CGPoint)velocity
{
    self.goal = goal;
    self.velocity = velocity;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScale)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.isScaling = YES;
}

- (void)stopScaling
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        
        self.isScaling = NO;
    }
}

- (void)updateScale
{
    CGFloat dp1, dp2, dv1, dv2, w1, w2, scale;
    integrate(self.frame.origin.x - self.goal.origin.x, self.velocity.x, &dp1, &dv1);
    integrate(self.frame.origin.y - self.goal.origin.y, self.velocity.y, &dp2, &dv2);
    
    w1 = self.frame.size.width;
    scale = scaleForDistance(self.referenceFrame.size.height, self.frame.size.height, dp2 * STEP_SIZE);
    self.transform = CGAffineTransformMakeScale(scale, scale);
    w2 = self.frame.size.width;
    
    self.layer.position = CGPointMake(self.center.x + dp1 * STEP_SIZE + (w2 - w1) / 2, self.center.y + (dp2 * STEP_SIZE) / 2);
    self.velocity = CGPointMake(self.velocity.x + dv1 * STEP_SIZE, self.velocity.y + dv2 * STEP_SIZE);
    
    if (fabs(self.frame.origin.x - self.goal.origin.x) <= 0.01f && fabs(self.frame.size.width - self.goal.size.width) <= 0.01f &&
        fabs(self.frame.origin.y - self.goal.origin.y) <= 0.01f && fabs(self.frame.size.height - self.goal.size.height) <= 0.01f) {
        [self stopScaling];
        
        self.transform = CGAffineTransformMakeScale(self.goal.size.width / self.referenceFrame.size.width,
                                                    self.goal.size.height / self.referenceFrame.size.height);
        self.layer.position = CGPointMake(CENTER(self.goal.origin.x, self.goal.size.width),
                                          CENTER(self.goal.origin.y, self.goal.size.height));
    }
}

#pragma mark - 

- (void)drawRect:(CGRect)rect
{
    CGRect strokeRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:2.0f];
    [[UIColor darkGrayColor] set];
    [path fill];
}

@end
