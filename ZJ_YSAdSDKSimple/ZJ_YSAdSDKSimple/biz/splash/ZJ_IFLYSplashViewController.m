#import "ZJ_IFLYSplashViewController.h"

#import "ZJ_IFLYADUtil.h"
#import <ZJ_YSAdSDK/ZJ_YSAdSDK.h>

@interface ZJ_IFLYSplashViewController () <ZJ_IFLYSplashAdDelegate>

@property (nonatomic, strong) ZJ_IFLYSplashAd *splashAd;
@property (nonatomic, strong) UISegmentedControl *slotControl;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextView *logView;

@end

@implementation ZJ_IFLYSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开屏广告";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self log:@"开屏示例：Load -> Ready -> Show"];
}

- (void)dealloc {
    [self.splashAd zj_destroy];
}

- (void)setupUI {
    CGFloat margin = 16;
    CGFloat width = self.view.bounds.size.width;
    CGFloat contentWidth = width - margin * 2;
    CGFloat y = 110;

    UILabel *desc = [ZJ_IFLYADUtil createSectionTitleWithText:@"开屏广告通常在启动页后展示。示例中手动点击 Show，便于观察完整生命周期。"
                                                     frame:CGRectMake(margin, y, contentWidth, 40)];
    [self.view addSubview:desc];
    y += 50;

    self.slotControl = [[UISegmentedControl alloc] initWithItems:@[@"图片开屏", @"视频开屏"]];
    self.slotControl.frame = CGRectMake(margin, y, contentWidth, 32);
    self.slotControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.slotControl];
    y += 48;

    CGFloat buttonWidth = (contentWidth - 8) / 2.0;
    UIButton *loadButton = [ZJ_IFLYADUtil createADTypeButtonWithFrame:CGRectMake(margin, y, buttonWidth, 44)
                                                            title:@"Load"
                                                           target:self
                                                           action:@selector(zj_loadAd)];
    [self.view addSubview:loadButton];

    self.showButton = [ZJ_IFLYADUtil createADTypeButtonWithFrame:CGRectMake(margin + buttonWidth + 8, y, buttonWidth, 44)
                                                        title:@"Show"
                                                       target:self
                                                       action:@selector(showAd)];
    [self setShowButtonEnabled:NO];
    [self.view addSubview:self.showButton];
    y += 54;

    UIButton *destroyButton = [ZJ_IFLYADUtil createSmallButtonWithTitle:@"Destroy"
                                                               color:UIColor.systemRedColor
                                                              target:self
                                                              action:@selector(destroyAd)];
    destroyButton.frame = CGRectMake(margin, y, buttonWidth, 34);
    [self.view addSubview:destroyButton];

    UIButton *statusButton = [ZJ_IFLYADUtil createSmallButtonWithTitle:@"检查状态"
                                                              color:UIColor.systemBlueColor
                                                             target:self
                                                             action:@selector(checkStatus)];
    statusButton.frame = CGRectMake(margin + buttonWidth + 8, y, buttonWidth, 34);
    [self.view addSubview:statusButton];
    y += 48;

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, contentWidth, 22)];
    self.statusLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    self.statusLabel.textColor = UIColor.systemBlueColor;
    self.statusLabel.text = @"等待加载";
    [self.view addSubview:self.statusLabel];
    y += 34;

    UILabel *logTitle = [ZJ_IFLYADUtil createSectionTitleWithText:@"回调日志"
                                                         frame:CGRectMake(margin, y, contentWidth, 18)];
    [self.view addSubview:logTitle];
    y += 22;

    CGFloat logHeight = MAX(300, self.view.bounds.size.height - y - 24);
    self.logView = [ZJ_IFLYADUtil createLogTextViewWithFrame:CGRectMake(margin, y, contentWidth, logHeight)];
    [self.view addSubview:self.logView];
}

- (void)zj_loadAd {
    [self destroyAdSilently];
    [self setShowButtonEnabled:NO];

    NSString *adUnitId = self.slotControl.selectedSegmentIndex == 1 ? __SPLASH_VIDEO_AD_UNIT_ID__ : __SPLASH_NATIVE_AD_UNIT_ID__;
    [self updateStatus:@"正在加载开屏" color:UIColor.systemBlueColor];
    [self log:[NSString stringWithFormat:@"Load adUnitId=%@", adUnitId]];

    ZJ_IFLYSplashAd *ad = [[ZJ_IFLYSplashAd alloc] initWithAdUnitId:adUnitId];
    ad.delegate = self;
    ad.currentViewController = self;
    self.splashAd = ad;
    [ad zj_loadAdWithRequestConfig:[ZJ_IFLYADUtil mediaSampleRequestConfig]];
}

- (void)showAd {
    if (!self.splashAd || ![self.splashAd zj_isAdValid]) {
        [self log:@"Show ignored: 开屏尚未 ready 或已失效"];
        [self updateStatus:@"请先等待 ready 回调" color:UIColor.systemRedColor];
        [self setShowButtonEnabled:NO];
        return;
    }

    ZJ_IFLYSplashAdConfig *config = [[ZJ_IFLYSplashAdConfig alloc] init];
    config.traceDuration = 5;
    config.mediumBottomView = [self bottomLogoView];
    config.muteOnStart = YES;
    config.muteButtonHidden = NO;
    [self log:@"调用 zj_showAdFromRootViewController:config:"];
    [self setShowButtonEnabled:NO];
    [self.splashAd zj_showAdFromRootViewController:self config:config];
}

- (UIView *)bottomLogoView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 90)];
    view.backgroundColor = UIColor.whiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"媒体 App Logo / 品牌区";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.darkTextColor;
    label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [view addSubview:label];
    return view;
}

- (void)destroyAd {
    [self destroyAdSilently];
    [self updateStatus:@"已销毁" color:[ZJ_IFLYADUtil demoTealColor]];
    [self log:@"Destroy"];
}

- (void)checkStatus {
    [self log:[NSString stringWithFormat:@"状态 zj_isAdValid=%@ %@",
                                      (self.splashAd && [self.splashAd zj_isAdValid]) ? @"YES" : @"NO",
                                      [ZJ_IFLYADUtil bidInfoSummaryForAd:self.splashAd]]];
}

- (void)destroyAdSilently {
    if (!self.splashAd) {
        return;
    }
    self.splashAd.delegate = nil;
    [self.splashAd zj_destroy];
    self.splashAd = nil;
    [self setShowButtonEnabled:NO];
}

- (void)setShowButtonEnabled:(BOOL)enabled {
    self.showButton.enabled = enabled;
    self.showButton.alpha = enabled ? 1.0 : 0.45;
}

- (void)updateStatus:(NSString *)text color:(UIColor *)color {
    self.statusLabel.text = text;
    self.statusLabel.textColor = color;
}

- (void)log:(NSString *)text {
    [ZJ_IFLYADUtil appendLog:text toTextView:self.logView];
    ZJ_IFLYSampleLogInfo(@"Splash", @"%@", text);
}

#pragma mark - ZJ_IFLYSplashAdDelegate

- (void)zj_splashAdDidLoad:(ZJ_IFLYSplashAd *)ad {
    [self log:[NSString stringWithFormat:@"splashAdDidLoad video=%@ landscape=%@ %@",
                                      ad.hasVideoTemplate ? @"YES" : @"NO",
                                      ad.isLandscapeTemplate ? @"YES" : @"NO",
                                      [ZJ_IFLYADUtil bidInfoSummaryForAd:ad]]];
    [self updateStatus:@"已加载，等待素材 ready" color:[ZJ_IFLYADUtil demoIndigoColor]];
}

- (void)zj_splashAdDidReady:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidReady"];
    [self updateStatus:@"开屏已 ready，可展示" color:UIColor.systemGreenColor];
    [self setShowButtonEnabled:ad == self.splashAd && [ad zj_isAdValid]];
}

- (void)zj_splashAdDidShow:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidShow"];
}

- (void)zj_splashAdDidExpose:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidExpose"];
}

- (void)zj_splashAdDidClick:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidClick"];
}

- (void)zj_splashAdDidClose:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidClose"];
    [self updateStatus:@"开屏已关闭" color:[ZJ_IFLYADUtil demoTealColor]];
}

- (void)zj_splashAdDidSkip:(ZJ_IFLYSplashAd *)ad {
    [self log:@"splashAdDidSkip"];
}

- (void)zj_splashAd:(ZJ_IFLYSplashAd *)ad didFailWithError:(ZJ_IFLYAdError *)error {
    [self log:[NSString stringWithFormat:@"splashAd didFailWithError %@", [ZJ_IFLYADUtil summaryForError:error]]];
    [self updateStatus:@"开屏加载或展示失败" color:UIColor.systemRedColor];
    [self setShowButtonEnabled:NO];
}

- (void)zj_splashAd:(ZJ_IFLYSplashAd *)ad didJumpWithSuccess:(BOOL)success {
    [self log:[NSString stringWithFormat:@"splashAd didJumpWithSuccess=%@", success ? @"YES" : @"NO"]];
}

@end
