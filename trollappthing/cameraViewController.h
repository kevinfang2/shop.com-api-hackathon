//
//  cameraViewController.h
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cameraViewController : UIViewController
@property NSMutableArray *nameArray;
@property NSMutableArray *linksArray;
@property NSMutableArray *imagesArray;
@property NSMutableArray *priceArray;
@property NSMutableArray *brandArray;

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;


- (NSData *)getRequest:(NSString *)itemName;
@end
