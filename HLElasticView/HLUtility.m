//
//  HLUtility.m
//  Playground
//
//  Created by Htin Linn on 2/11/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLUtility.h"

// http://squareb.wordpress.com/2013/01/06/31/

CGFloat rubberBandedValueForDistance(CGFloat distance)
{
    CGFloat constant = 0.30f; // UIScrollView default value == 0.55f
    CGFloat dimension = SCREEN_HEIGHT;
    
    return (1.0f - (1.0f / ((distance * constant / dimension) + 1.0))) * dimension;
}

CGFloat dampedValue(CGFloat origin, CGFloat length, CGFloat delta, CGFloat upperThreshold)
{
    CGFloat newDelta = delta;
    
    if (origin < 0.0f) {
        newDelta = rubberBandedValueForDistance(delta);
    } else if (origin + length > upperThreshold) {
        newDelta = rubberBandedValueForDistance(delta);
    } else if (origin + delta < 0.0f) {
        newDelta = rubberBandedValueForDistance(origin + delta) - origin;
    } else if (origin + length + delta > upperThreshold) {
        newDelta = rubberBandedValueForDistance(origin + length + delta - upperThreshold) + (upperThreshold - origin - length);
    }
    
    return newDelta;
}

CGPoint dampedDistance(CGRect frame, CGPoint delta)
{
    CGFloat deltaX = dampedValue(frame.origin.x, frame.size.width, delta.x, SCREEN_WIDTH);
    CGFloat deltaY = dampedValue(frame.origin.y, frame.size.height, delta.y, SCREEN_HEIGHT - VIEW_OFFSET);
        
    return CGPointMake(deltaX, deltaY);
}

CGFloat scaleForDistance(CGFloat referenceLength, CGFloat currentLength, CGFloat delta)
{
    return (currentLength - delta) / referenceLength; // Neg Delta = Scale Up; Pos Delta = Scale Down
}

CGFloat dampedScale(CGRect referenceFrame, CGRect currentFrame, CGFloat *delta)
{
    *delta = dampedValue(currentFrame.origin.y, 0.0f, *delta, referenceFrame.origin.y);
    return scaleForDistance(referenceFrame.size.height, currentFrame.size.height, *delta);
}

//https://twitter.com/lorenb/status/408068815369412608
//http://gafferongames.com/game-physics/integration-basics/
//https://github.com/facebook/rebound/blob/master/rebound-js/rebound.js
//http://stackoverflow.com/questions/7365090/damping-effect-of-spring-mass-system-or-is-this-elasticease
//http://ariya.ofilabs.com/2011/10/flick-list-with-its-momentum-scrolling-and-deceleration.html

CGFloat accelerationForPosition(CGFloat position, CGFloat velocity)
{
	return - SPRING_CONSTANT * position - DAMPING_CONSTANT * velocity;
}

void integrate(CGFloat currentPosition, CGFloat currentVelocity, CGFloat *dxdt, CGFloat *dvdt)
{
    CGFloat aPosition = currentVelocity;
    CGFloat aVelocity = accelerationForPosition(currentPosition, currentVelocity);
    
    CGFloat bPosition = currentVelocity + STEP_SIZE * 0.5f * aVelocity;
    CGFloat bVelocity = accelerationForPosition(currentPosition + STEP_SIZE * 0.5f * aPosition, currentVelocity + STEP_SIZE * 0.5f * aVelocity);
    
    CGFloat cPosition = currentVelocity + STEP_SIZE * 0.5f * bVelocity;
    CGFloat cVelocity = accelerationForPosition(currentPosition + STEP_SIZE * 0.5f * bPosition, currentVelocity + STEP_SIZE * 0.5f * bVelocity);
    
    CGFloat dPosition = currentVelocity + STEP_SIZE * cVelocity;
    CGFloat dVelocity = accelerationForPosition(currentPosition + STEP_SIZE * cPosition, currentVelocity + STEP_SIZE * cVelocity);
    
    *dxdt = 1.0f/6.0f * (aPosition + 2.0f*(bPosition + cPosition) + dPosition);
    *dvdt = 1.0f/6.0f * (aVelocity + 2.0f*(bVelocity + cVelocity) + dVelocity);
}