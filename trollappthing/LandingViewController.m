//
//  LandingViewController.m
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import "LandingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "imagesViewController.h"

@interface LandingViewController (){
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UIButton *cameraButton;
    __weak IBOutlet UILabel *titleLabel;
}

@end

#define dWidth self.view.frame.size.width
#define dHeight self.view.frame.size.height

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchButton.backgroundColor = [UIColor whiteColor];
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    
    cameraButton.backgroundColor = [UIColor whiteColor];
    cameraButton.layer.cornerRadius = 5;
    cameraButton.layer.masksToBounds = YES;
    
    NSMutableAttributedString *mat = [titleLabel.attributedText mutableCopy];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    titleLabel.attributedText = mat;

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}

- (void)dealloc {
    self.adView = nil;
}



//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

@end
