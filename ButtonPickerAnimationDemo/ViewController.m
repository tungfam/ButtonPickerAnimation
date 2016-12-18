//
//  ViewController.m
//  ButtonPickerAnimationDemo
//
//  Created by Tung Fam on 12/18/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

#import "ViewController.h"

static NSInteger const heartRightMargin = 42;
static NSInteger const navigationItemHeight = 44;
static NSString* const startSegueIdentifier = @"starSegue";
static CGFloat const buttonWidth = 50;
static CGFloat const buttonHeight = 50;

@interface ViewController ()

@property (assign, nonatomic, readwrite) CBFeedbackState state;

@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *dislikeButton;
@property (strong, nonatomic) UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *heartLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation ViewController

#pragma mark: - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = CBFeedbackStateEmpty;
    [self initButtons];
    [self setInitialPositionsForButtons];
    
    self.loadingIndicator.hidesWhenStopped = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: Private methods

- (void)initButtons
{
    if (self.likeButton == nil) {
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.likeButton addTarget:self
                            action:@selector(likeAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        // for selected state
        UIImage *imageLike = [[UIImage imageNamed:@"like"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.likeButton setImage:imageLike forState:UIControlStateSelected];
        self.likeButton.tintColor = [UIColor colorWithRed: 7/255.0 green: 215/255.0 blue: 7/255.0 alpha: 1.0];
    }
    
    if (self.dislikeButton == nil) {
        self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dislikeButton addTarget:self
                               action:@selector(dislikeAction:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.dislikeButton setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        // for selected state
        UIImage *imageDislike = [[UIImage imageNamed:@"dislike"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.dislikeButton setImage:imageDislike forState:UIControlStateSelected];
        self.dislikeButton.tintColor = [UIColor colorWithRed: 255/255.0 green: 0/255.0 blue: 30/255.0 alpha: 1.0];
    }
    
    if (self.heartButton == nil) {
        self.heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.heartButton addTarget:self
                             action:@selector(heartAction:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.heartButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        // for selected state
        UIImage *imageHeart = [[UIImage imageNamed:@"heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.heartButton setImage:imageHeart forState:UIControlStateSelected];
        self.heartButton.tintColor = [UIColor colorWithRed: 255/255.0 green: 0/255.0 blue: 30/255.0 alpha: 1.0];
    }
}

- (void)setInitialPositionsForButtons
{
    UIView *parentView = self.view;
    
    // LIKE button
    self.likeButton.transform = CGAffineTransformIdentity; // we need this to discard changes of button after animation
    self.likeButton.frame = CGRectMake(50, 50, buttonWidth, buttonHeight);
    [parentView addSubview:self.likeButton];
    
    CGRect likeButtonFrame = self.likeButton.frame;
    likeButtonFrame.origin = CGPointMake(35, 60.0 + navigationItemHeight);
    self.likeButton.frame = likeButtonFrame;
    self.likeButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    
    // DISLIKE button
    self.dislikeButton.transform = CGAffineTransformIdentity; // we need this to discard changes of button after animation
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.dislikeButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, 65 + navigationItemHeight, buttonWidth, buttonHeight);
    self.dislikeButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [parentView addSubview:self.dislikeButton];
    
    // HEART button
    self.heartButton.transform = CGAffineTransformIdentity; // we need this to discard changes of button after animation
    self.heartButton.frame = CGRectMake(50, 50, buttonWidth, buttonHeight);
    self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [parentView addSubview:self.heartButton];
    CGRect heartButtonFrame = self.heartButton.frame;
    CGFloat xPositionBlock = CGRectGetWidth(parentView.frame) - CGRectGetWidth(heartButtonFrame) - heartRightMargin;
    heartButtonFrame.origin = CGPointMake(ceil(xPositionBlock), 62.0 + navigationItemHeight);
    self.heartButton.frame = heartButtonFrame;
    self.heartButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    // heart label
    self.heartLabel.alpha = 0.0;
}

- (void)setState:(CBFeedbackState)state animated:(BOOL)animated
{
    if (_state == state) return;
    _state = state;
    switch (state) {
        case CBFeedbackStateLiked:
            self.likeButton.selected = YES;
            [self setSubviewsForStateAnimated:YES state:state];
            [self performAnimation:state animated:animated];
            break;
        case CBFeedbackStateDisliked:
            self.dislikeButton.selected = YES;
            [self setSubviewsForStateAnimated:YES state:state];
            [self performAnimation:state animated:animated];
            break;
        case CBFeedbackStateHeart:
        {
            [self setSubviewsForStateAnimated:animated state:state];
            [self performAnimation:state animated:animated];
            double delayInSeconds = (animated ? 0.2 : 0.0);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.heartButton.selected = YES;
            });
        }
            break;
        default: // CBFeedbackStateEmpty
        {
            double delayInSeconds = (animated ? 0.5 : 0.0);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self setInitialPositionsForButtons];
            });
            [self performAnimation:CBFeedbackStateEmpty animated:animated];
            [self setSubviewsForStateAnimated:animated state:state];
            break;
        }
    }
}

#pragma mark: Animation methods

- (void)setSubviewsForStateAnimated:(BOOL)animated state:(CBFeedbackState)state
{
    NSTimeInterval animationDuration = (animated ? 0.2 : 0.0);
    float hide = 0.0;
    float show = 1.0;
    
    switch (state)
    {
        case CBFeedbackStateLiked:
        case CBFeedbackStateDisliked:
        {
            [UIView animateWithDuration:animationDuration animations:^{
                self.likeButton.alpha = hide;
                self.heartButton.alpha = hide;
                self.dislikeButton.alpha = hide;
                
                /* you may add more things like labels or elements that you want to hide */
                
            }];
        }
            break;
        case CBFeedbackStateHeart:
        {
            [UIView animateWithDuration:animationDuration animations:^{
                
                self.likeButton.alpha = hide;
                self.heartButton.alpha = hide;
                self.dislikeButton.alpha = hide;
            }];
            double delayInSeconds = (animated ? 0.4 : 0.0);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [UIView animateWithDuration:animationDuration animations:^{
                    self.heartLabel.alpha = show;
                }];
            });
        }
            break;
        default: // feedback empty state
        {
            // this block will be 'played' first
            [UIView animateWithDuration:animationDuration animations:^{
                self.heartLabel.alpha = hide;
                
            }];
            
            // this block will be 'played' second after 0.5 sec delay (if animated is true)
            double delayInSeconds = (animated ? 0.6 : 0.0);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.likeButton.selected = NO;
                self.dislikeButton.selected = NO;
                self.heartButton.selected = NO;
                
                [UIView animateWithDuration:animationDuration animations:^{
                    self.heartLabel.alpha = hide;
                    self.likeButton.alpha = show;
                    self.heartButton.alpha = show;
                    self.dislikeButton.alpha = show;
                }];
            });
        }
            break;
    }
}

- (void)performAnimation:(CBFeedbackState)state animated:(BOOL)animated
{
    switch (state) {
        case CBFeedbackStateEmpty:
        {
            UIButton *button = nil;
            if (self.likeButton.alpha == 1) {
                button = self.likeButton;
            }
            else if (self.dislikeButton.alpha == 1) {
                button = self.dislikeButton;
            }
            else if (self.heartButton.alpha == 1)   {
                button = self.heartButton;
            }
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            [UIView animateWithDuration:0.2 animations:^{
                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0001, 0.0001);
                } completion:^(BOOL finished) {
                    button.alpha = 0.0;
                }];
            }];
        }
            break;
            
        default:
        {
            double delay = (animated ? 0.2 : 0);
            double durationAnimation = (animated ? 0.2 : 0);
            
            double delayInSeconds = delay;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.loadingIndicator startAnimating];
                [self.loadingIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:delay];
                
                /* you may perform the server request when it's animating indicator */
                
                double delayInSeconds = delay;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    switch (state) {
                        case CBFeedbackStateHeart:
                        {
                            UIView *view = self.view;
                            self.heartButton.alpha = 1.0;
                            CGRect buttonFrame = self.heartButton.frame;
                            CGFloat xPositionBlock = CGRectGetWidth(view.frame) - CGRectGetWidth(buttonFrame) - heartRightMargin;
                            buttonFrame.origin = CGPointMake(ceil(xPositionBlock), 58.0 + navigationItemHeight);
                            self.heartButton.frame = buttonFrame;
                            
                            self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                            
                            [UIView animateWithDuration:durationAnimation animations:^{
                                self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:durationAnimation animations:^{
                                    self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                                } completion:^(BOOL finished) {
                                }];
                            }];
                            break;
                        }
                        default:
                        {
                            UIButton *button = nil;
                            switch (state) {
                                case CBFeedbackStateLiked:
                                    button = self.likeButton;
                                    break;
                                case CBFeedbackStateDisliked:
                                    button = self.dislikeButton;
                                default:
                                    break;
                            }
                            button.alpha = 1.0;
                            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                            button.frame = CGRectMake(screenWidth/2 - buttonWidth/2, 60 + navigationItemHeight, buttonWidth, buttonHeight);
                            
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                            
                            [UIView animateWithDuration:durationAnimation animations:^{
                                button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:durationAnimation animations:^{
                                    button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                                } completion:^(BOOL finished) {
                                }];
                            }];
                            break;
                        }
                    }
                });
            });
        }
            break;
    }
}


#pragma mark: Private Actions

- (IBAction)likeAction:(UIButton *)sender
{
    CBFeedbackState stateToSet = (self.state == CBFeedbackStateEmpty ? CBFeedbackStateLiked : CBFeedbackStateEmpty);
    [self setState:stateToSet animated:YES];
}

- (IBAction)dislikeAction:(UIButton *)sender
{
    CBFeedbackState stateToSet = (self.state == CBFeedbackStateEmpty ? CBFeedbackStateDisliked : CBFeedbackStateEmpty);
    [self setState:stateToSet animated:YES];
}

- (IBAction)heartAction:(UIButton *)sender
{
    CBFeedbackState stateToSet = (self.state == CBFeedbackStateEmpty ? CBFeedbackStateHeart : CBFeedbackStateEmpty);
    [self setState:stateToSet animated:YES];
}

- (IBAction)openStarVC:(UIButton *)sender {
    [self performSegueWithIdentifier:startSegueIdentifier sender:self];
}

@end
