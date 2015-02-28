//
//  DXLoadingTool.h
//
//  Created by 徐 东 on 13-6-28.
//
//


@interface DXLoadingTool : NSObject

typedef void(^LoadingToolInterceptor)(UIView *view);

+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifer;
+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifer timeout:(NSTimeInterval)timeout;

+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifer;
+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifer timeout:(NSTimeInterval)timeout;
+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifer;
+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifer timeout:(NSTimeInterval)timeout;
+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifer;
+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifer timeout:(NSTimeInterval)timeout;
/**
 *@param identifer this ID MUST be unique in application context
 */
+ (void)showLoadingForView:(UIView *)view ID:(NSString *)identifer loadingInterceptor:(LoadingToolInterceptor)loadingInterceptor idleInterceptor:(LoadingToolInterceptor)idleInterceptor timeout:(NSTimeInterval)timeout;
/**
 *use in tableview context,MUST be balanced with resumeLoadingForView: call
 */
+ (void)pauseLoadingForID:(NSString *)identifer;
/**
 *use in tableview context,MUST be balanced with pauseLoadingForID: call
 */
+ (void)resumeLoadingForID:(NSString *)identifer view:(UIView *)view;

+ (void)hideLoadingForID:(NSString *)identifer;

+ (BOOL)isIDPausedLoading:(NSString *)identifer;

@end
