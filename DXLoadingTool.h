//
//  DXLoadingTool.h
//
//  Created by 徐 东 on 13-6-28.
//
//


@interface DXLoadingTool : NSObject

typedef void(^LoadingToolInterceptor)(UIView *view);

+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifier;
+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout;

+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifier;
+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout;
+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifier;
+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout;
+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifier;
+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout;
/**
 *@param identifier this ID MUST be unique in application context
 */
+ (void)showLoadingForView:(UIView *)view ID:(NSString *)identifier loadingInterceptor:(LoadingToolInterceptor)loadingInterceptor idleInterceptor:(LoadingToolInterceptor)idleInterceptor timeout:(NSTimeInterval)timeout;
/**
 *use in tableview context,MUST be balanced with resumeLoadingForView: call
 */
+ (void)pauseLoadingForID:(NSString *)identifier;
/**
 *use in tableview context,MUST be balanced with pauseLoadingForID: call
 */
+ (void)resumeLoadingForID:(NSString *)identifier view:(UIView *)view;

+ (void)hideLoadingForID:(NSString *)identifier;

+ (BOOL)isIDPausedLoading:(NSString *)identifier;

@end
