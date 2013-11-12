//
//  DXLoadingTool.m
//
//  Created by 徐 东 on 13-6-28.
//
//

#import "DXLoadingTool.h"

@interface LoadingInfo : NSObject

@property (strong) LoadingToolInterceptor loadingInterceptor;
@property (strong) LoadingToolInterceptor idleInterceptor;
@property (strong) NSDate *timeoutLine;
@property (assign) BOOL paused;
@property (weak) UIView *targetView;

@end

@implementation LoadingInfo

@end

@implementation DXLoadingTool

static NSString *LOADING_INTERCEPTOR_KEY = @"loading_tool_loading_interceptor";
static NSString *IDLE_INTERCEPTOR_KEY = @"loading_tool_idle_interceptor";
static NSMutableDictionary *idInfoMap;

+ (void)load
{
    [super load];
    idInfoMap = [NSMutableDictionary dictionary];
}

+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout
{
    CGRect frame = view.frame;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    [self showLoadingForView:view ID:identifier loadingInterceptor:^(UIView *view) {
        view.hidden = YES;
        UIView *parent = view.superview;
        [parent addSubview:indicator];
        [indicator startAnimating];
    } idleInterceptor:^(UIView *view) {
        view.hidden = NO;
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    } timeout:timeout];
}

+ (void)showLoadingInDefaultModeForView:(UIView *)view ID:(NSString *)identifier
{
    [self showLoadingInDefaultModeForView:view ID:identifier timeout:DBL_MAX];
}

+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout
{
    CGAffineTransform transform = view.transform;
    [self showLoadingForView:view ID:identifier loadingInterceptor:^(UIView *view) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            view.transform = CGAffineTransformMakeRotation(0.35);//0.35 radians = 20 degree
            view.transform = CGAffineTransformMakeRotation(-0.35);
        } completion:nil];
    } idleInterceptor:^(UIView *view) {
        view.transform = transform;
        [view.layer removeAllAnimations];
    } timeout:timeout];
}

+ (void)showLoadingInRotateModeForView:(UIView *)view ID:(NSString *)identifier
{
    [self showLoadingInRotateModeForView:view ID:identifier timeout:DBL_MAX];
}

+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout
{
    CGAffineTransform transform = view.transform;
    [self showLoadingForView:view ID:identifier loadingInterceptor:^(UIView *view) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            view.transform = CGAffineTransformMakeScale(0.9, 0.9);
            view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:nil];
    } idleInterceptor:^(UIView *view) {
        view.transform = transform;
        [view.layer removeAllAnimations];
    } timeout:timeout];
}

+ (void)showLoadingInScaleModeForView:(UIView *)view ID:(NSString *)identifier
{
    [self showLoadingInScaleModeForView:view ID:identifier timeout:DBL_MAX];
}

+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifier timeout:(NSTimeInterval)timeout
{
    CGFloat alpha = view.alpha;
    [self showLoadingForView:view ID:identifier loadingInterceptor:^(UIView *view) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            view.alpha = 0.8;
        } completion:nil];
        
    } idleInterceptor:^(UIView *view) {
        view.alpha = alpha;
        [view.layer removeAllAnimations];
    } timeout:timeout];
}

+ (void)showLoadingInAlphaModeForView:(UIView *)view ID:(NSString *)identifier
{
    [self showLoadingInAlphaModeForView:view ID:identifier timeout:DBL_MAX];
}

+ (void)showLoadingForView:(UIView *)view ID:(NSString *)identifier loadingInterceptor:(LoadingToolInterceptor)loadingInterceptor idleInterceptor:(LoadingToolInterceptor)idleInterceptor timeout:(NSTimeInterval)timeout
{
    LoadingInfo *info = (LoadingInfo *)idInfoMap[identifier];
    if ([info.targetView isEqual:view]) {
        return;
    }
    
    if (loadingInterceptor) {
        loadingInterceptor(view);
        info = [[LoadingInfo alloc]init];
        idInfoMap[identifier] = info;
        info.loadingInterceptor = [loadingInterceptor copy];
        info.idleInterceptor = [idleInterceptor copy];
        info.timeoutLine = [NSDate dateWithTimeIntervalSinceNow:timeout];
        info.targetView = view;
        [self performSelector:@selector(hideLoadingForID:) withObject:identifier afterDelay:timeout];
    }
}

+ (void)pauseLoadingForID:(NSString *)identifier
{
    
    LoadingInfo *info = idInfoMap[identifier];
    LoadingToolInterceptor idle = info.idleInterceptor;
    UIView *view = info.targetView;
    if (idle) {
        idle(view);
    }
    info.targetView = nil;
}

+ (void)resumeLoadingForView:(UIView *)view ID:(NSString *)identifier
{
    LoadingInfo *info = (LoadingInfo *)idInfoMap[identifier];
    LoadingToolInterceptor loadingInterceptor = info.loadingInterceptor;
    if (loadingInterceptor) {
        loadingInterceptor(view);
        info.targetView = view;
    }
}

+ (void)hideLoadingForID:(NSString *)identifier
{
    LoadingInfo *info = idInfoMap[identifier];
    LoadingToolInterceptor idle = info.idleInterceptor;
    UIView *view = info.targetView;
    if (idle) {
        idle(view);
    }
    [idInfoMap removeObjectForKey:identifier];
    [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLoadingForID:) object:identifier];
}

+ (BOOL)isIdPausedLoading:(NSString *)identifier
{
    return identifier.length > 0 && !((LoadingInfo *)idInfoMap[identifier]).targetView;
}

@end

