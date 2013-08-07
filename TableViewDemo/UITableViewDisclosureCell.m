//
//  UITableViewDisclosureCell.m
//  TableViewDemo
//
//  Created by Eytan Moudahi on 2013-08-05.
//  Copyright (c) 2013 PPG. All rights reserved.
//

#import "UITableViewDisclosureCell.h"

typedef enum {
    UITableViewDisclosureCellStateConcealed,                // Normal. The primary view is front and center. 
    UITableViewDisclosureCellStateConcealingFromLeft,       // The primary view is to the left and is moving right.
    UITableViewDisclosureCellStateConcealingFromRight,      // The primary view is to the right and is moving left.
    UITableViewDisclosureCellStateDisclosing,               // The primary view is being hidden left or right
    UITableViewDisclosureCellStateDisclosedLeft,            // The primary view is hidden to the left
    UITableViewDisclosureCellStateDisclosedRight            // The primary view is hidden to the right
    } UITableViewDisclosureCellState;

@interface UITableViewDisclosureCell ()
@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) UITableViewDisclosureCellState state;
@end

@implementation UITableViewDisclosureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.secondaryView = [[UIView alloc] init];
        self.secondaryView.frame = self.contentView.bounds;
        self.secondaryView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.secondaryView];
        
        self.primaryView = [[UIView alloc] init];
        self.primaryView.frame = self.contentView.bounds;
        self.primaryView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.primaryView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [panGesture setDelegate:self];
        [self addGestureRecognizer:panGesture];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.primaryView.frame = self.contentView.bounds;
    self.secondaryView.frame = self.contentView.bounds;
}

- (CGRect)frameForProgress:(float)progress
{
    NSAssert(-1 <= progress && progress <= 1, @"titleFrameForProgress requires a progress on the domain [-1,1] inclusive");
    
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat y = 0;
    
    CGFloat x;
    CGRect frame;
    
    switch (self.state) {
        
        // Static states. The progress is irrelevent if in these states. 
        case UITableViewDisclosureCellStateConcealed:
            frame = CGRectMake(0, 0, width, height);
            break;
        case UITableViewDisclosureCellStateDisclosedLeft:
            frame = CGRectMake(-width, 0, width, height);
            break;
        case UITableViewDisclosureCellStateDisclosedRight:
            frame = CGRectMake(width, 0, width, height);
            break;
            
            
        // Transition States. The primary view was centered, but is now moving left or right.
        case UITableViewDisclosureCellStateDisclosing:
        {
            x = progress*width;
            frame = CGRectMake(x, y, width, height);
            break;
        }
        
        // Transition state. The primary view was left and is moving right. 
        case UITableViewDisclosureCellStateConcealingFromLeft:
        {
            if (progress >= 0) {
                x = -width + progress * width;
                frame = CGRectMake(x, y, width, height);
            } else {
                x = -width;
                frame = CGRectMake(x, y, width, height);
            }
            break;
        }
            
        // Transition state. The primary view was right and is moving left. 
        case UITableViewDisclosureCellStateConcealingFromRight:
        {
            if (progress <= 0) {
                x = width + progress * width;
                frame = CGRectMake(x, y, width, height);
            } else {
                x = width;
                frame = CGRectMake(x, y, width, height);
            }
            break;
        }
    }
    
    return frame;
    
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    NSAssert(-1 <= progress && progress <= 1, @"setProgress:animated: requires a progress on the domain [-1,1] inclusive");
    self.primaryView.frame = [self frameForProgress:progress];
    _progress = progress;
}

- (void)concealSecondaryViewAnimated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.5 : 0;
    
    self.state = UITableViewDisclosureCellStateConcealed;
    
    self.isAnimating = YES;
    [UIView animateWithDuration:duration animations:^{
        [self setProgress:0 animated:NO];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

#pragma mark - Gesture Support

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
        BOOL isHorizontal = fabs(velocity.y)/(fabs(velocity.x) + 1) < 0.35;
        BOOL validStartState = (self.state == UITableViewDisclosureCellStateDisclosedLeft
                                || self.state == UITableViewDisclosureCellStateDisclosedRight
                                || self.state == UITableViewDisclosureCellStateConcealed);
        BOOL isNotAnimating = !self.isAnimating;
        return isNotAnimating && validStartState && isHorizontal && [self.delegate disclosureCell:self shouldRespondToGesture:gestureRecognizer];
    } else {
        return YES;
    }
}

- (void)panGestureRecognized:(UIPanGestureRecognizer*)panGesture
{
    
    CGFloat MAX_TRANSLATION = CGRectGetWidth(self.contentView.bounds);
    CGPoint translation = [panGesture translationInView:self.superview];
    CGPoint velocity = [panGesture velocityInView:self.superview];
    
    CGFloat progress = MAX(MIN(translation.x/MAX_TRANSLATION,1),-1);
        
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            switch (self.state) {
                case UITableViewDisclosureCellStateConcealed:
                    [self.delegate disclosureCellWillDisclose:self];
                    self.state = UITableViewDisclosureCellStateDisclosing;
                    break;

                case UITableViewDisclosureCellStateDisclosedLeft:
                    [self.delegate disclosureCellWillConceal:self];
                    self.state = UITableViewDisclosureCellStateConcealingFromLeft;
                    break;
                    
                case UITableViewDisclosureCellStateDisclosedRight:
                    [self.delegate disclosureCellWillConceal:self];
                    self.state = UITableViewDisclosureCellStateConcealingFromRight;
                    break;
                    
                case UITableViewDisclosureCellStateConcealingFromLeft:
                case UITableViewDisclosureCellStateConcealingFromRight:
                case UITableViewDisclosureCellStateDisclosing:
                    abort();
                    break;
            }
            
            [self setProgress:progress animated:NO];

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self setProgress:progress animated:NO];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {            
            // When the touch gesture ends, we either a) return the view to its original location, b) slide it completely off according to the following criteria: If the translation is in the neighbourhood of CGPointZero, we return to the original location.
            self.isAnimating = YES;
            CGFloat TRANSLATION_WATERSHED = 50;
            if (abs(translation.x) < TRANSLATION_WATERSHED) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self setProgress:0 animated:NO];
                } completion:^(BOOL finished) {
                    self.isAnimating = NO;
                    
                    if (self.state == UITableViewDisclosureCellStateDisclosing) {
                        [self.delegate disclosureCellDidConceal:self];
                        self.state = UITableViewDisclosureCellStateConcealed;
                    } else if (self.state == UITableViewDisclosureCellStateConcealingFromLeft) {
                        [self.delegate disclosureCellDidDisclose:self];
                        self.state = UITableViewDisclosureCellStateDisclosedLeft;
                    } else if (self.state == UITableViewDisclosureCellStateConcealingFromRight) {
                        [self.delegate disclosureCellDidDisclose:self];                        
                        self.state = UITableViewDisclosureCellStateDisclosedRight;
                    }
                    
                }];
            }
            else {
                
                CGFloat finalProgress = (translation.x > 0) ? 1 : -1;
                CGFloat timeVelocity = fabs((finalProgress - self.progress)/velocity.x)*MAX_TRANSLATION;
                CGFloat time = MIN(timeVelocity, 0.5);
                
                if (self.state == UITableViewDisclosureCellStateDisclosing && finalProgress == 1) {
                    self.state = UITableViewDisclosureCellStateDisclosedRight;
                } else if (self.state == UITableViewDisclosureCellStateDisclosing && finalProgress == -1) {
                    self.state = UITableViewDisclosureCellStateDisclosedLeft;
                } else {
                    self.state = UITableViewDisclosureCellStateConcealed;
                }
                
                [UIView animateWithDuration:time animations:^{
                    [self setProgress:0 animated:NO];
                } completion:^(BOOL finished) {
                    self.isAnimating = NO;
                   
                    if (self.state == UITableViewDisclosureCellStateDisclosedRight
                        || self.state == UITableViewDisclosureCellStateDisclosedLeft) {
                        [self.delegate disclosureCellDidDisclose:self];
                    } else {
                        [self.delegate disclosureCellDidConceal:self];
                    }
                    
                }];
            }
            
        }
        default:
            break;
    }
}

@end
