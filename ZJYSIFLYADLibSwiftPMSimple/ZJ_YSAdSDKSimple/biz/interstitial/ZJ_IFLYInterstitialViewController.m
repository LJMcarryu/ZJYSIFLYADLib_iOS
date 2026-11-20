#import "ZJ_IFLYInterstitialViewController.h"

#import "ZJ_IFLYADUtil.h"
#import <ZJ_YSAdSDK/ZJ_YSAdSDK.h>

@interface ZJ_IFLYInterstitialViewController () <ZJ_IFLYInterstitialAdDelegate>

@property (nonatomic, strong) ZJ_IFLYInterstitialAd *interstitialAd;
@property (nonatomic, strong) UISegmentedControl *styleControl;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextView *logView;

@end

@implementation ZJ_IFLYInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"插屏广告";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self log:@"插屏示例：Load -> Ready -> Show -> Close"];
}

- (void)dealloc {
    [self.interstitialAd zj_destroy];
}

- (void)setupUI {
    CGFloat margin = 16;
    CGFloat width = self.view.bounds.size.width;
    CGFloat contentWidth = width - margin * 2;
    CGFloat y = 110;

    UILabel *desc = [ZJ_IFLYADUtil createSectionTitleWithText:@"插屏由 SDK 负责渲染和 present。媒体侧在 didReady 后传入展示配置并调用 show。"
                                                     frame:CGRectMake(margin, y, contentWidth, 38)];
    [self.view addSubview:desc];
    y += 48;

    self.styleControl = [[UISegmentedControl alloc] initWithItems:@[@"半屏", @"全屏"]];
    self.styleControl.frame = CGRectMake(margin, y, contentWidth, 32);
    self.styleControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.styleControl];
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

    CGFloat logHeight = MAX(260, self.view.bounds.size.height - y - 24);
    self.logView = [ZJ_IFLYADUtil createLogTextViewWithFrame:CGRectMake(margin, y, contentWidth, logHeight)];
    [self.view addSubview:self.logView];
}

- (void)zj_loadAd {
    [self destroyAdSilently];
    [self setShowButtonEnabled:NO];
    [self updateStatus:@"正在加载插屏" color:UIColor.systemBlueColor];
    [self log:[NSString stringWithFormat:@"Load adUnitId=%@", __INTERSTITIAL_AD_UNIT_ID__]];

    ZJ_IFLYInterstitialAd *ad = [[ZJ_IFLYInterstitialAd alloc] initWithAdUnitId:__INTERSTITIAL_AD_UNIT_ID__];
    ad.delegate = self;
    ad.currentViewController = self;
    self.interstitialAd = ad;
    [ad zj_loadAdWithRequestConfig:[ZJ_IFLYADUtil mediaSampleRequestConfig]];
}

- (void)showAd {
    if (!self.interstitialAd || ![self.interstitialAd zj_isAdValid]) {
        [self log:@"Show ignored: 插屏尚未 ready 或已失效"];
        [self updateStatus:@"请先等待 ready 回调" color:UIColor.systemRedColor];
        [self setShowButtonEnabled:NO];
        return;
    }

    ZJ_IFLYInterstitialAdConfig *config = [[ZJ_IFLYInterstitialAdConfig alloc] init];
    config.presentationStyle = self.styleControl.selectedSegmentIndex == 1
                                   ? ZJ_IFLYInterstitialPresentationStyleFullScreen
                                   : ZJ_IFLYInterstitialPresentationStyleHalfScreen;
    config.muteOnStart = YES;
    config.muteButtonHidden = NO;
    [self log:[NSString stringWithFormat:@"调用 show，style=%@", self.styleControl.selectedSegmentIndex == 1 ? @"全屏" : @"半屏"]];
    [self setShowButtonEnabled:NO];
    [self.interstitialAd zj_showAdFromRootViewController:self config:config];
}

- (void)destroyAd {
    [self destroyAdSilently];
    [self updateStatus:@"已销毁" color:[ZJ_IFLYADUtil demoTealColor]];
    [self log:@"Destroy"];
}

- (void)checkStatus {
    [self log:[NSString stringWithFormat:@"状态 zj_isAdValid=%@ %@",
                                      (self.interstitialAd && [self.interstitialAd zj_isAdValid]) ? @"YES" : @"NO",
                                      [ZJ_IFLYADUtil bidInfoSummaryForAd:self.interstitialAd]]];
}

- (void)destroyAdSilently {
    if (!self.interstitialAd) {
        return;
    }
    self.interstitialAd.delegate = nil;
    [self.interstitialAd zj_destroy];
    self.interstitialAd = nil;
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
    ZJ_IFLYSampleLogInfo(@"Interstitial", @"%@", text);
}

#pragma mark - ZJ_IFLYInterstitialAdDelegate

- (void)zj_interstitialAdDidLoad:(ZJ_IFLYInterstitialAd *)ad {
    [self log:[NSString stringWithFormat:@"interstitialAdDidLoad video=%@ landscape=%@ %@",
                                      ad.hasVideoTemplate ? @"YES" : @"NO",
                                      ad.isLandscapeTemplate ? @"YES" : @"NO",
                                      [ZJ_IFLYADUtil bidInfoSummaryForAd:ad]]];
    [self updateStatus:@"已加载，等待素材 ready" color:[ZJ_IFLYADUtil demoIndigoColor]];
}

- (void)zj_interstitialAdDidReady:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidReady"];
    [self updateStatus:@"插屏已 ready，可展示" color:UIColor.systemGreenColor];
    [self setShowButtonEnabled:ad == self.interstitialAd && [ad zj_isAdValid]];
}

- (void)zj_interstitialAdDidShow:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidShow"];
}

- (void)zj_interstitialAdDidRender:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidRender"];
}

- (void)zj_interstitialAdDidExpose:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidExpose"];
    [self updateStatus:@"插屏已曝光" color:UIColor.systemGreenColor];
}

- (void)zj_interstitialAdDidClick:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidClick"];
}

- (void)zj_interstitialAdDidClose:(ZJ_IFLYInterstitialAd *)ad {
    [self log:@"interstitialAdDidClose"];
    [self updateStatus:@"插屏已关闭" color:[ZJ_IFLYADUtil demoTealColor]];
}

- (void)zj_interstitialAd:(ZJ_IFLYInterstitialAd *)ad didFailWithError:(ZJ_IFLYAdError *)error {
    [self log:[NSString stringWithFormat:@"interstitialAd didFailWithError %@", [ZJ_IFLYADUtil summaryForError:error]]];
    [self updateStatus:@"插屏加载或展示失败" color:UIColor.systemRedColor];
    [self setShowButtonEnabled:NO];
}

- (void)zj_interstitialAd:(ZJ_IFLYInterstitialAd *)ad didFailToRenderWithError:(ZJ_IFLYAdError *)error {
    [self log:[NSString stringWithFormat:@"interstitialAd didFailToRender %@", [ZJ_IFLYADUtil summaryForError:error]]];
}

- (void)zj_interstitialAd:(ZJ_IFLYInterstitialAd *)ad didJumpWithSuccess:(BOOL)success {
    [self log:[NSString stringWithFormat:@"interstitialAd didJumpWithSuccess=%@", success ? @"YES" : @"NO"]];
}

@end
