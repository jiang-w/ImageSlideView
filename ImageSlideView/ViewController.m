//
//  ViewController.m
//  ImageSlideView
//
//  Created by Frank on 15/12/18.
//  Copyright © 2015年 jiangw. All rights reserved.
//

#import "ViewController.h"
#import "ImageSlideView.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    UIImage *img1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.chinabigdata.com/images/Banner1.jpg"]]];
    UIImage *img2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.chinabigdata.com/images/Banner2.jpg"]]];
    UIImage *img3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.chinabigdata.com/images/Banner3.jpg"]]];
    [images addObject:img1];
    [images addObject:img2];
    [images addObject:img3];
    
    ImageSlideView *imgSlide = [[ImageSlideView alloc] init];
    imgSlide.images = images;
    [self.view addSubview:imgSlide];
    [imgSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view).sizeOffset(CGSizeMake(0, -500));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
