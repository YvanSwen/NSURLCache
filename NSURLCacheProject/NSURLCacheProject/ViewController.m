//
//  ViewController.m
//  NSURLCacheProject
//
//  Created by Yvan on 15/12/30.
//  Copyright © 2015年 Yvan. All rights reserved.
//

#import "ViewController.h"

#define kUrl @"http://f.hiphotos.baidu.com/image/pic/item/3bf33a87e950352a230666de5743fbf2b3118b85.jpg"

@interface ViewController ()

{
    NSURLCache *cache;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    cache = [NSURLCache sharedURLCache];
    NSLog(@"磁盘缓存容量%ldM, 缓存已用磁盘容量%ldM",cache.diskCapacity/1024/1024, cache.currentDiskUsage/1024/1024);
//    1M = 1024KB = 1024*1024Bytes
    NSLog(@"内存缓存容量%ldM, 缓存已用内存容量%ldM", cache.memoryCapacity/1024/1024, cache.currentMemoryUsage/1024/1024);
    cache.memoryCapacity = 10 * 1024 * 1024;
    NSLog(@"内存缓存容量%ldM, 缓存已用内存容量%ldM", cache.memoryCapacity/1024/1024, cache.currentMemoryUsage/1024/1024);
    
    [self requestWithUrl:kUrl];
}

- (void)requestWithUrl:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
   NSURLSessionDataTask *task =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       // 网络请求一定会有 response, 但是不一定会有data
        // 构造一个缓存对象
        NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
       // 如果之前请求过这个数据就不再继续请求
       if (cacheResponse) {
           NSString *string = [[NSString alloc] initWithData:cacheResponse.data encoding:NSUTF8StringEncoding];;
           NSLog(@"之前请求过这个数据:%@", string);
           
           return;
       }
        // 将缓存对象存到 NSURLCache 中
        [cache storeCachedResponse:cacheResponse forRequest:request];
        NSLog(@"%@", [cache cachedResponseForRequest:request].response);
        NSLog(@"磁盘缓存容量%ldM, 缓存已用磁盘容量%ldM",cache.diskCapacity/1024/1024, cache.currentDiskUsage/1024/1024);
        //    1M = 1024KB = 1024*1024Bytes
        NSLog(@"内存缓存容量%ldM, 缓存已用内存容量%ldM", cache.memoryCapacity/1024/1024, cache.currentMemoryUsage/1024/1024);
        cache.memoryCapacity = 10 * 1024 * 1024;
        NSLog(@"内存缓存容量%ldM, 缓存已用内存容量%ldM", cache.memoryCapacity/1024/1024, cache.currentMemoryUsage/1024/1024);
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
