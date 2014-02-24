//
//  HLElasticScaleView.h
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLElasticScaleView : UIView

@property (nonatomic, assign) BOOL isScaling;

- (void)translate:(CGPoint)distance;
- (void)scale:(CGRect)goal withVelocity:(CGPoint)velocity;
- (void)stopScaling;

@end
