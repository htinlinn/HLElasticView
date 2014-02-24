//
//  HLElasticSnapView.m
//  Playground
//
//  Created by Htin Linn on 2/11/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLElasticSnapView.h"
#import "HLUtility.h"

@interface HLElasticSnapView ()
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint goal;
@property (nonatomic, strong) CADisplayLink *displayLink;

- (void)updateLocation;
@end

@implementation HLElasticSnapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowOpacity = 0.5f;
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}


#pragma mark -

- (void)translate:(CGPoint)distance
{
    CGPoint newDistance = dampedDistance(self.frame, distance);
    
    self.layer.position = CGPointMake(CENTER(self.frame.origin.x, self.frame.size.width) + newDistance.x,
                                      CENTER(self.frame.origin.y, self.frame.size.height) + newDistance.y);
}

- (void)snapToPoint:(CGPoint)point withVelocity:(CGPoint)velocity
{
    self.goal = point;
    self.velocity = velocity;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLocation)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopSnapping
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}


#pragma mark -

- (void)updateLocation
{
    CGFloat dp1, dp2, dv1, dv2;
    integrate(self.layer.position.x - self.goal.x, self.velocity.x, &dp1, &dv1);
    integrate(self.layer.position.y - self.goal.y, self.velocity.y, &dp2, &dv2);
    
    self.layer.position = CGPointMake(self.layer.position.x + dp1 * STEP_SIZE, self.layer.position.y + dp2 * STEP_SIZE);
    self.velocity = CGPointMake(self.velocity.x + dv1 * STEP_SIZE, self.velocity.y + dv2 * STEP_SIZE);
    
    if (fabs(self.layer.position.y - self.goal.y) <= 0.01f && fabs(self.velocity.y) < 0.01f &&
        fabs(self.layer.position.x - self.goal.x) <= 0.01f && fabs(self.velocity.x) < 0.01f) {
        [self stopSnapping];
        self.layer.position = self.goal;
    }
}

@end
