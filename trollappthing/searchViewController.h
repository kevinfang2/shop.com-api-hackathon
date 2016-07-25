//
//  searchViewController.h
//  trollappthing
//
//  Created by family on 7/24/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cameraViewController.h"

@interface searchViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSMutableArray *nameArray;
@property NSMutableArray *priceArray;
@property NSMutableArray *linksArray;
@property NSMutableArray *imagesArray;
@end
