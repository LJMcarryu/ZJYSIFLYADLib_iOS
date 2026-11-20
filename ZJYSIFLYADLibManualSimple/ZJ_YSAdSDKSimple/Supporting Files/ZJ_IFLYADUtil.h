//
//  ZJ_IFLYADUtil.h
//  ZJ_YSAdSDKSimple
//
//  Created by admin on 6.3.25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZJ_IFLYAdError;
@class ZJ_IFLYAdBase;
@class ZJ_IFLYAdRequestConfig;

NS_ASSUME_NONNULL_BEGIN

@interface ZJ_IFLYADUtil : NSObject

+ (UIButton *)createADTypeButtonWithFrame:(CGRect)frame
                                    title:(NSString *)title
                                   target:(nullable id)target
                                   action:(SEL)action;
+ (UIButton *)createSmallButtonWithTitle:(NSString *)title
                                   color:(UIColor *)color
                                  target:(nullable id)target
                                  action:(SEL)action;
+ (UILabel *)createSectionTitleWithText:(NSString *)text frame:(CGRect)frame;
+ (UITextView *)createLogTextViewWithFrame:(CGRect)frame;
+ (UIColor *)demoSecondaryLabelColor;
+ (UIColor *)demoIndigoColor;
+ (UIColor *)demoTealColor;
+ (void)appendLog:(NSString *)text toTextView:(UITextView *)textView;
+ (ZJ_IFLYAdRequestConfig *)mediaSampleRequestConfig;
+ (NSString *)summaryForError:(nullable ZJ_IFLYAdError *)error;
/// 返回严格白名单竞价字段 price / dealId 的日志摘要。
+ (NSString *)bidInfoSummaryForAd:(nullable ZJ_IFLYAdBase *)ad;
+ (void)loadImageWithURLString:(NSString *)urlString
                    completion:(void (^)(UIImage *_Nullable image, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
