//
//  imagesViewController.h
//  trollappthing
//
//  Created by Kevin Fang on 7/3/16.
//  Copyright © 2016 Kevin Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPAdInfo;

@interface imagesViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property NSMutableArray *namesArray;
@property NSMutableArray *pricesArray;
@property NSMutableArray *linksArray;
@property NSMutableArray *imagesArray;
@property NSMutableArray *brandArray;

- (id)initWithAdInfo:(MPAdInfo *)info;

@end
