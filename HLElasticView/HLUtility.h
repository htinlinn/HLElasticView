//
//  HLUtility.h
//  Playground
//
//  Created by Htin Linn on 2/11/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPRING_CONSTANT 250.0f
#define DAMPING_CONSTANT 30.0f
#define STEP_SIZE 1/60.0f
#define VIEW_OFFSET 64.0f
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CENTER(origin, length) (origin + (length / 2))

CGPoint dampedDistance(CGRect frame, CGPoint delta);
CGFloat scaleForDistance(CGFloat referenceLength, CGFloat currentLength, CGFloat delta);
CGFloat dampedScale(CGRect referenceFrame, CGRect currentFrame, CGFloat *delta);
void integrate(CGFloat currentPosition, CGFloat currentVelocity, CGFloat *dxdt, CGFloat *dvdt);