//
//  ViewController.m
//  ZJ_YSAdSDKSimple
//
//  Created by admin on 3.3.25.
//

#import "ZJ_IFLYInterstitialViewController.h"
#import "ZJ_IFLYNativeViewController.h"
#import "ZJ_IFLYSplashViewController.h"
#import "ViewController.h"

#import "ZJ_IFLYADUtil.h"
#import <ZJ_YSAdSDK/ZJ_YSAdSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZJ_YSAdSDK 示例";
    self.view.backgroundColor = UIColor.whiteColor;
    [self initADTypeListView];
}

- (void)initADTypeListView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];

    CGFloat width = self.view.bounds.size.width;
    CGFloat margin = 24;
    CGFloat contentWidth = width - margin * 2;
    CGFloat y = 24;

    UILabel *versionLabel =
        [ZJ_IFLYADUtil createSectionTitleWithText:[NSString stringWithFormat:@"SDK Version: %@", [ZJ_IFLYAdTool zj_sdkVersion]]
                                         frame:CGRectMake(margin, y, contentWidth, 20)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:versionLabel];
    y += 36;

    UILabel *descLabel = [ZJ_IFLYADUtil
        createSectionTitleWithText:@"先配置自己的广告位，再按加载、展示、回调、销毁顺序体验。接入步骤和排错方法见示例 README。"
                             frame:CGRectMake(margin, y, contentWidth, 52)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:descLabel];
    y += 72;

    NSArray<NSDictionary<NSString *, NSString *> *> *items = @[
        @{@"title" : @"开屏广告", @"selector" : @"splashADTypeClick:"},
        @{@"title" : @"插屏广告", @"selector" : @"interstitialADTypeClick:"},
        @{@"title" : @"自渲染信息流", @"selector" : @"nativeADTypeClick:"},
    ];

    for (NSDictionary<NSString *, NSString *> *item in items) {
        SEL selector = NSSelectorFromString(item[@"selector"]);
        UIButton *button = [ZJ_IFLYADUtil createADTypeButtonWithFrame:CGRectMake(margin, y, contentWidth, 48)
                                                             title:item[@"title"]
                                                            target:self
                                                            action:selector];
        [scrollView addSubview:button];
        y += 62;
    }

    scrollView.contentSize = CGSizeMake(width, y + 24);
}

- (void)splashADTypeClick:(UIButton *)sender {
    [self.navigationController pushViewController:ZJ_IFLYSplashViewController.alloc.init animated:YES];
}

- (void)nativeADTypeClick:(UIButton *)sender {
    [self.navigationController pushViewController:ZJ_IFLYNativeViewController.alloc.init animated:YES];
}


- (void)interstitialADTypeClick:(UIButton *)sender {
    [self.navigationController pushViewController:ZJ_IFLYInterstitialViewController.alloc.init animated:YES];
}

@end
