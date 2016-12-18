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

@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


@end
