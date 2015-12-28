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
@property(nonatomic, weak) NSTimer *timer;

@end

@implementation ImageSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageScroll];
    }
    return self;
}

- (void)layoutSubviews {
    if (self.images.count > 1 && !CGSizeEqualToSize(self.imageScroll.contentSize, CGSizeZero)) {
        UIImageView *firstImage = self.imageViews[1];
//        NSLog(@"image frame: %@", NSStringFromCGRect(firstImage.frame));
        self.imageScroll.contentOffset = firstImage.frame.origin;
    }
}

- (void)updateConstraints {
    [self.imageScroll mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imgView = self.imageViews[i];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.imageScroll);
            make.top.bottom.equalTo(self.imageScroll);
            
            if (i == 0) {
                make.left.equalTo(self.imageScroll);
            }
            else {
                UIImageView *pervImgView = self.imageViews[i - 1];
                make.left.equalTo(pervImgView.mas_right);
            }
            
            if (i == self.imageViews.count - 1) {
                make.right.equalTo(self.imageScroll);
            }
        }];
    }
    
    [super updateConstraints];
}


#pragma mark - private

- (void)clearAllImages {
    for (UIImageView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
}

- (void)revolvingScroll {
    CGFloat pageWidth = CGRectGetWidth(self.imageScroll.frame);
    CGFloat xOffset = self.imageScroll.contentOffset.x;
    if (xOffset == self.imageScroll.contentSize.width - pageWidth * 2) {
        xOffset = 0;
        [self.imageScroll setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    }
    NSLog(@"xOffset begin: %f", xOffset);
    [self.imageScroll setContentOffset:CGPointMake(xOffset + pageWidth, 0) animated:YES];
    NSLog(@"xOffset begin: %f", xOffset + pageWidth);
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
        
        _imageScroll.backgroundColor = [UIColor lightGrayColor];
//        _imageScroll.clipsToBounds = NO;
    }
    return _imageScroll;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)setImages:(NSArray<UIImage *> *)images {
    if (_images != images) {
        if (self.timer) {
            [self.timer invalidate];
        }
        
        _images = images;
        [self clearAllImages];
        
        for (UIImage *img in _images) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
            [self.imageViews addObject:imageView];
            [self.imageScroll addSubview:imageView];
        }
        if (_images.count > 1) {
            UIImageView *leading = [[UIImageView alloc] initWithImage:[_images lastObject]];
            [self.imageViews insertObject:leading atIndex:0];
            [self.imageScroll addSubview:leading];
            UIImageView *trailing = [[UIImageView alloc] initWithImage:[_images firstObject]];
            [self.imageViews addObject:trailing];
            [self.imageScroll addSubview:trailing];
        }
        
        [self setNeedsUpdateConstraints];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(revolvingScroll) userInfo:nil repeats:YES];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self
                                                selector:@selector(revolvingScroll) userInfo:nil repeats:YES];
}

@end
