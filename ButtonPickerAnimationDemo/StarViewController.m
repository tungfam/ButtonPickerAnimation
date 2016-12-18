//
//  StarViewController.m
//  ButtonPickerAnimationDemo
//
//  Created by Tung Fam on 12/18/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

#import "StarViewController.h"

static NSTimeInterval const animationDuration = 0.2;


@interface StarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;

@end

@implementation StarViewController

#pragma mark: Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStarButton];
    [self setupHeartButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: Actions

- (IBAction)starAction:(UIButton *)sender {
    self.starButton.selected = !self.starButton.selected;
    [self setStarSelected:self.starButton.selected];
}

- (void)setStarSelected:(BOOL)selected
{
    if (selected)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            self.starButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration - 0.1 animations:^{
                self.starButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            } completion:^(BOOL finished) {
            }];
        }];
    }
    else
    {
        self.starButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        [UIView animateWithDuration:0.2 animations:^{
            self.starButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.starButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];

    }
}

- (IBAction)heartAction:(UIButton *)sender {
    [self setHeartSelected:!self.heartButton.selected];
}

- (void)setHeartSelected:(BOOL)selected
{
    if (selected)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0001, 0.0001);
        } completion:^(BOOL finished) {
            self.heartButton.selected = !self.heartButton.selected;
            [UIView animateWithDuration:animationDuration animations:^{
                self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:animationDuration animations:^{
                    self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                } completion:^(BOOL finished) {
                }];
            }];
        }];
    }
    else
    {
        self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        [UIView animateWithDuration:animationDuration - 0.1 animations:^{
            self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0001, 0.0001);
            } completion:^(BOOL finished) {
                self.heartButton.selected = !self.heartButton.selected;
                [UIView animateWithDuration:animationDuration animations:^{
                    self.heartButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                } completion:^(BOOL finished) {
                }];
            }];
        }];
        
    }
}

#pragma mark: UI methods

- (void)setupStarButton
{
    [self.starButton setImage:[UIImage imageNamed:@"star_default"] forState:UIControlStateNormal];
    
    // SELECTED STATE OF BUTTON
    /* if you have an image for 'selected' state just uncomment the  line below */
    //    [self.starButton setImage:[UIImage imageNamed:@"star_selected"] forState:UIControlStateSelected];
    /* if you don't, as me. use code below to change color of button */
    UIImage *imageHeart = [[UIImage imageNamed:@"star_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.starButton setImage:imageHeart forState:UIControlStateSelected];
    self.starButton.tintColor = [UIColor colorWithRed: 246/255.0 green: 199/255.0 blue: 0/255.0 alpha: 1.0];
    
    // for highlighted state
    UIImage *imageHeartHighlighted = [[UIImage imageNamed:@"star_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.starButton setImage:imageHeartHighlighted forState:UIControlStateHighlighted];
    self.starButton.tintColor = [UIColor colorWithRed: 246/255.0 green: 199/255.0 blue: 0/255.0 alpha: 1.0];
}

- (void)setupHeartButton
{
    [self.heartButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    
    // for selected state
    UIImage *imageHeart = [[UIImage imageNamed:@"heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.heartButton setImage:imageHeart forState:UIControlStateSelected];
    self.heartButton.tintColor = [UIColor colorWithRed: 255/255.0 green: 0/255.0 blue: 30/255.0 alpha: 1.0];
}


@end
