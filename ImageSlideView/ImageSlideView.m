//
//  ImageSlideView.m
//  ImageSlideView
//
//  Created by Frank on 15/12/18.
//  Copyright © 2015年 jiangw. All rights reserved.
//

#import "ImageSlideView.h"
#import <Masonry.h>

@interface ImageSlideView()

@property(nonatomic, strong) UIScrollView *imageScroll;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

@end

@implementation ImageSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageScroll = [[UIScrollView alloc] init];
        _imageScroll.delegate = self;
        [self addSubview:_imageScroll];
        [_imageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _imageWidth = frame.size.width;
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (void)setImages:(NSArray<UIImage *> *)images {
    if (_images != images) {
        _images = images;
        [self clearAllImages];
        
        if (_images.count > 0) {
            CGFloat imageWidth = self.imageWidth;
            CGFloat imageHeight = self.imageScroll.frame.size.height;
            self.imageScroll.contentSize = CGSizeMake(imageWidth * _images.count, imageHeight);

            for (int i = 0; i < _images.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:_images[i]];
                imageView.frame = CGRectMake(imageWidth * i, 0, imageWidth, imageHeight);
                [self.imageScroll addSubview:imageView];
            }
        }
    }
}


- (void)clearAllImages {
    for (UIView *imageView in self.imageScroll.subviews) {
        [imageView removeFromSuperview];
    }
    self.imageScroll.contentSize = self.imageScroll.frame.size;
}

@end
