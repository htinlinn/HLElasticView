//
//  HLSnapViewController.m
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLSnapViewController.h"
#import "HLElasticSnapView.h"
#import "HLUtility.h"

#define SNAP_VIEW_HEIGHT (SCREEN_HEIGHT - VIEW_OFFSET) / 2.5f
#define TIPPING_POINT (SCREEN_HEIGHT - VIEW_OFFSET - SNAP_VIEW_HEIGHT) / 2.0f

@interface HLSnapViewController ()
@property (nonatomic, strong) HLElasticSnapView *snapView;
@property (nonatomic, assign) CGPoint translation;

- (void)handlePan:(id)sender;
@end

@implementation HLSnapViewController

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.snapView = [[HLElasticSnapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SNAP_VIEW_HEIGHT)];
    [self.view addSubview:self.snapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.snapView addGestureRecognizer:panGestureRecognizer];
}


#pragma mark -

- (void)handlePan:(id)sender
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint newTranslation = [recognizer translationInView:self.view];
    CGPoint translationDelta = CGPointMake(newTranslation.x - self.translation.x, newTranslation.y - self.translation.y);
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self.snapView stopSnapping];
            
            translationDelta = CGPointMake(0.0f, 0.0f);
            [self.snapView translate:translationDelta];
            
            break;
        } case UIGestureRecognizerStateChanged: {
            [self.snapView translate:translationDelta];
            
            break;
        } case UIGestureRecognizerStateEnded: {
            [self.snapView translate:translationDelta];
            
            CGPoint velocity = [recognizer velocityInView:self.view];
            CGPoint topAnchor = CGPointMake(self.snapView.frame.size.width / 2, self.snapView.frame.size.height / 2);
            CGPoint bottomAnchor = CGPointMake(self.snapView.frame.size.width / 2, self.view.frame.size.height - self.snapView.frame.size.height / 2);
            
            if (self.snapView.frame.origin.y + velocity.y <= 0.0f) {
                [self.snapView snapToPoint:topAnchor withVelocity:velocity];
            } else if (self.snapView.frame.origin.y + self.snapView.frame.size.height + velocity.y >= self.view.frame.size.height) {
                [self.snapView snapToPoint:bottomAnchor withVelocity:velocity];
            } else {
                if (self.snapView.frame.origin.y <= TIPPING_POINT) {
                    [self.snapView snapToPoint:topAnchor withVelocity:velocity];
                } else if (self.snapView.frame.origin.y > TIPPING_POINT) {
                    [self.snapView snapToPoint:bottomAnchor withVelocity:velocity];
                }
            }
            
            break;
        } default:
            break;
    }
    
    self.translation = newTranslation;
}


@end
