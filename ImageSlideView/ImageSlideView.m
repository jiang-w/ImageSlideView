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
@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

@end

@implementation ImageSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    if (!CGSizeEqualToSize(self.imageScroll.contentSize, CGSizeZero)) {
        if (self.images.count > 1) {
            UIImageView *firstImage = self.imageViews[1];
            self.imageScroll.contentOffset = firstImage.frame.origin;
        }
    }
}


#pragma mark - private

- (void)initView {
    [self addSubview:self.imageScroll];
    [self.imageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.imageScroll addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageScroll);
        make.height.equalTo(self.imageScroll);
    }];
    
//    UIView *frame = [UIView new];
//    [self.imageScroll addSubview:frame];
//    frame.layer.borderColor = [UIColor redColor].CGColor;
//    frame.layer.borderWidth = 2.0f;
//    [frame mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.imageScroll);
//    }];
}

- (void)setImageViewAndLayout {
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imgView = self.imageViews[i];
        [self.container addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.imageScroll);
            
            if (i == 0) {
                make.left.top.bottom.equalTo(self.container);
            }
            else {
                UIImageView *pervImgView = self.imageViews[i - 1];
                make.left.equalTo(pervImgView.mas_right);
                make.top.bottom.equalTo(self.container);
            }

            if (i == self.imageViews.count - 1) {
                make.right.equalTo(self.container);
            }
        }];
    }
}

- (void)clearAllImages {
    for (UIImageView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
}


#pragma mark - property

- (UIScrollView *)imageScroll {
    if (!_imageScroll) {
        _imageScroll = [[UIScrollView alloc] init];
        _imageScroll.showsHorizontalScrollIndicator = NO;
        _imageScroll.showsVerticalScrollIndicator = NO;
        _imageScroll.pagingEnabled = YES;
        _imageScroll.bounces = NO;
        _imageScroll.delegate = self;
        
//        _imageScroll.backgroundColor = [UIColor lightGrayColor];
//        _imageScroll.clipsToBounds = NO;
    }
    return _imageScroll;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        
//        _container.backgroundColor = [UIColor blueColor];
//        _container.alpha = 0.5;
    }
    return _container;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)setImages:(NSArray<UIImage *> *)images {
    if (_images != images) {
        _images = images;
        [self clearAllImages];
        
        for (UIImage *img in _images) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
            [self.imageViews addObject:imageView];
        }
        if (_images.count > 1) {
            UIImageView *leading = [[UIImageView alloc] initWithImage:[_images lastObject]];
            [self.imageViews insertObject:leading atIndex:0];
            UIImageView *trailing = [[UIImageView alloc] initWithImage:[_images firstObject]];
            [self.imageViews addObject:trailing];
        }
        
        [self setImageViewAndLayout];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.images.count > 1) {
        CGPoint currentOffset = self.imageScroll.contentOffset;
        CGPoint firstImageOffset = self.imageViews[1].frame.origin;
        CGPoint lastImageOffset = self.imageViews[self.images.count].frame.origin;
        
        if (CGPointEqualToPoint(currentOffset, [self.imageViews firstObject].frame.origin)) {
            self.imageScroll.contentOffset = lastImageOffset;
        }
        if (CGPointEqualToPoint(currentOffset, [self.imageViews lastObject].frame.origin)) {
            self.imageScroll.contentOffset = firstImageOffset;
        }
    }
}

@end
