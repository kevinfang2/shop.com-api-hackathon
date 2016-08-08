//
//  LandingViewController.h
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPAdView.h"

@interface LandingViewController : UIViewController <UINavigationControllerDelegate, MPAdViewDelegate>

@property (nonatomic, retain) MPAdView *adView;

@end
