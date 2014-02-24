//
//  HLScaleViewController.m
//  HLElasticView
//
//  Created by Htin Linn on 2/23/14.
//  Copyright (c) 2014 Htin Linn. All rights reserved.
//

#import "HLScaleViewController.h"
#import "HLElasticScaleView.h"
#import "HLUtility.h"

#define SCALE_VIEW_HEIGHT (SCREEN_HEIGHT - VIEW_OFFSET) / 2.5f
#define SCALE_VIEW_WIDTH SCREEN_WIDTH / 2.5f
#define TIPPING_POINT (SCREEN_HEIGHT - VIEW_OFFSET - SCALE_VIEW_HEIGHT) / 2.0f

@interface HLScaleViewController ()
@property (nonatomic, strong) HLElasticScaleView *scaleView;
@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGPoint translation;
@property (nonatomic, assign) BOOL panningActive;

- (void)handlePan:(id)sender;
- (void)handleTap:(id)sender;
@end


@implementation HLScaleViewController

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scaleView = [[HLElasticScaleView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCALE_VIEW_WIDTH) / 2.0f, SCREEN_HEIGHT - VIEW_OFFSET - SCALE_VIEW_HEIGHT, SCALE_VIEW_WIDTH, SCALE_VIEW_HEIGHT)];
    [self.view addSubview:self.scaleView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.scaleView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.scaleView addGestureRecognizer:tapGestureRecognizer];
    
    self.panningActive = NO;
}


#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(id)sender
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint newTranslation = [recognizer translationInView:self.view];
    CGPoint translationDelta = CGPointMake(newTranslation.x - self.translation.x, newTranslation.y - self.translation.y);
    translationDelta = CGPointMake(translationDelta.x, translationDelta.y * self.scaleFactor);
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self.scaleView stopScaling];
            
            self.scaleFactor = SCALE_VIEW_HEIGHT / (SCALE_VIEW_HEIGHT - [recognizer locationInView:self.scaleView].y);
            if (self.scaleFactor < 1.0f) {
                self.scaleFactor = 1.0f;
            }
            
            translationDelta = CGPointMake(0.0f, 0.0f);
            [self.scaleView translate:translationDelta];
            
            self.panningActive = YES;
            
            break;
        } case UIGestureRecognizerStateChanged: {
            [self.scaleView translate:translationDelta];
            
            break;
        } case UIGestureRecognizerStateEnded: {
            [self.scaleView translate:translationDelta];
            
            CGPoint velocity = [recognizer velocityInView:self.view];
            CGRect fullFrame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
            CGRect smallFrame = CGRectMake((SCREEN_WIDTH - SCALE_VIEW_WIDTH) / 2.0f, SCREEN_HEIGHT - VIEW_OFFSET - SCALE_VIEW_HEIGHT, SCALE_VIEW_WIDTH, SCALE_VIEW_HEIGHT);
            
            if (self.scaleView.frame.origin.y + velocity.y <= 0.0f) {
                [self.scaleView scale:fullFrame withVelocity:velocity];
            } else if (self.scaleView.frame.origin.y + velocity.y >= self.view.frame.size.height - smallFrame.size.height) {
                [self.scaleView scale:smallFrame withVelocity:velocity];
            } else {
                if (self.scaleView.frame.origin.y <= TIPPING_POINT) {
                    [self.scaleView scale:fullFrame withVelocity:velocity];
                } else if (self.scaleView.frame.origin.y > TIPPING_POINT) {
                    [self.scaleView scale:smallFrame withVelocity:velocity];
                }
            }
            
            self.panningActive = NO;
            
            break;
        } default:
            break;
    }
    
    self.translation = newTranslation;
}

- (void)handleTap:(id)sender
{    
    CGRect fullFrame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    if (self.scaleView.frame.size.height < fullFrame.size.height && !self.panningActive && !self.scaleView.isScaling) {
        [self.scaleView stopScaling];
        [self.scaleView scale:fullFrame withVelocity:CGPointZero];
    }
}





@end
