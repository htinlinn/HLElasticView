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
    CGFloat constant = 0.35f; // UIScrollView default value == 0.55f
    CGFloat dimension = 960.0f;
    
    return (1.0f - (1.0f / ((distance * constant / dimension) + 1.0))) * dimension;
}

CGFloat dampedValue(CGFloat origin, CGFloat length, CGFloat delta, CGFloat upperThreshold)
{
    CGFloat newDelta = delta;
    
    if (origin < 0.0f) {
        if (delta < 0.0f) {
            newDelta = rubberBandedValueForDistance(delta);
        }
    } else if (origin + length > upperThreshold) {
        if (delta > 0.0f) {
            newDelta = rubberBandedValueForDistance(delta);
        }
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
    CGFloat deltaY = dampedValue(frame.origin.y, frame.size.height, delta.y, SCREEN_HEIGHT);
    
    return CGPointMake(deltaX, deltaY);
}
