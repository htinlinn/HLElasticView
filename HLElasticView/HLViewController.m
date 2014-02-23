//
//  HLViewController.m
//  HLElasticView
//
//  Created by Htin Linn on 2/22/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLViewController.h"
#import "HLElasticView.h"
#import "HLUtility.h"

#define VIEW_HEIGHT ceilf(SCREEN_HEIGHT / 2.25f)
#define TIPPING_POINT (SCREEN_HEIGHT - VIEW_HEIGHT) / 2.0f

@interface HLViewController ()
@property (nonatomic, strong) HLElasticView *grayView;
@property (nonatomic, assign) CGPoint translation;

- (void)handlePan:(id)sender;
@end


@implementation HLViewController

- (void)loadView
{
    [super loadView];
    
    self.grayView = [[HLElasticView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT - VIEW_HEIGHT, 320.0f, VIEW_HEIGHT)];
    [self.view addSubview:self.grayView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.grayView addGestureRecognizer:panGestureRecognizer];
}


#pragma mark - 

- (void)handlePan:(id)sender
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint newTranslation = [recognizer translationInView:self.view];
    CGPoint translationDelta = CGPointMake(newTranslation.x - self.translation.x, newTranslation.y - self.translation.y);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        translationDelta = CGPointMake(0.0f, 0.0f);
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self.grayView stopSnapping];
            [self.grayView translate:translationDelta];
            
            break;
        } case UIGestureRecognizerStateChanged: {
            [self.grayView translate:translationDelta];
            
            break;
        } case UIGestureRecognizerStateEnded: {
            [self.grayView translate:translationDelta];
            
            CGPoint velocity = [recognizer velocityInView:self.view];
            CGPoint topAnchor = CGPointMake(self.grayView.frame.size.width / 2, self.grayView.frame.size.height / 2);
            CGPoint bottomAnchor = CGPointMake(self.grayView.frame.size.width / 2, SCREEN_HEIGHT - self.grayView.frame.size.height / 2);
            
            if (self.grayView.center.y + velocity.y <= topAnchor.y) {
                [self.grayView snapToPoint:topAnchor withVelocity:velocity];
            } else if (self.grayView.center.y + velocity.y >= bottomAnchor.y) {
                [self.grayView snapToPoint:bottomAnchor withVelocity:velocity];
            } else {
                if (self.grayView.frame.origin.y <= TIPPING_POINT) {
                    [self.grayView snapToPoint:topAnchor withVelocity:velocity];
                } else if (self.grayView.frame.origin.y > TIPPING_POINT) {
                    [self.grayView snapToPoint:bottomAnchor withVelocity:velocity];
                }
            }
            
            break;
        } default:
            break;
    }
    
    self.translation = newTranslation;
}

@end
