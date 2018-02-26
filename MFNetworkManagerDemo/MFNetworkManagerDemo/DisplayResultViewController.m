//
//  DisplayResultViewController.m
//  MFNetworkManagerDemo
//
//  Created by pipelining on 2018/2/26.
//  Copyright © 2018年 pipelining. All rights reserved.
//

#import "DisplayResultViewController.h"
#import "MFNetworkManager.h"
@interface DisplayResultViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DisplayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 150)];
    self.textView.backgroundColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    self.textView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textView.frame) + 10, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20)];
    self.imageView.backgroundColor = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
    [self.view addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self load];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"--------------------");
    [MFNETWROK cancelRequestWithURL:@"https://cdn.gratisography.com/photos/440H.jpg"];
    
}

- (void)load {
    if (self.type == 0) {
        [MFNETWROK get:@"http://httpbin.org/get" params:@{
                                                          @"custom_param": @"mf_param"
                                                          } success:^(id result, NSURLSessionDataTask *task) {
                                                              NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                                                              NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  self.textView.text = str;
                                                              });
                                                          } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  self.textView.text = error.localizedDescription;
                                                              });
                                                          }];
    }else if (self.type == 1) {
        MFNETWROK.requestType = MFRequestTypeJSON;//观察比较注视这句时的content-Type
        [MFNETWROK post:@"http://httpbin.org/post" params:@{
                                                            @"custom_param": @"mf_param"
                                                            } success:^(id result, NSURLSessionDataTask *task) {
                                                                NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                                                                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    self.textView.text = str;
                                                                });
                                                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    self.textView.text =error.localizedDescription;
                                                                });
                                                            }];

    }else if (self.type == 2) {
        [MFNETWROK upload:@"http://httpbin.org/post" params:@{
                                                              @"custom_param": @"mf_param"
                                                              } name:@"name" images:self.imageList imageScale:0.1 imageType:@"png" progress:^(NSProgress *progress) {
                                                                  NSLog(@"--%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
                                                              } success:^(id result, NSURLSessionDataTask *task) {
                                                                  NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                                                                  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                  NSString *base64 = [result[@"files"][@"name"] substringFromIndex:22];
                                                                  NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      self.textView.text = str;
                                                                      self.imageView.image = [UIImage imageWithData:base64Data];
                                                                  });
                                                              } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      self.textView.text =error.localizedDescription;
                                                                  });
                                                              }];
    }else {
        [MFNETWROK download:@"https://cdn.gratisography.com/photos/440H.jpg" fileDir:@"Download" progress:^(NSProgress *progress) {
            NSLog(@"--%f",1.0 * progress.completedUnitCount / progress.totalUnitCount);
        } success:^(NSString *path) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithContentsOfFile:path];
                self.textView.text = path;
            });
        } failure:^(NSError *error, NSURLSessionDataTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = error.localizedDescription;
            });
        }];
    }
}




@end
