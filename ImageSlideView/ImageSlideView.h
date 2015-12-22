//
//  ImageSlideView.h
//  ImageSlideView
//
//  Created by Frank on 15/12/18.
//  Copyright © 2015年 jiangw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSlideView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) NSArray<UIImage *> *images;

@end
