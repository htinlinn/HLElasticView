//
//  HLElasticSnapView.h
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLElasticSnapView : UIView

- (void)translate:(CGPoint)distance;
- (void)snapToPoint:(CGPoint)point withVelocity:(CGPoint)velocity;
- (void)stopSnapping;

@end
