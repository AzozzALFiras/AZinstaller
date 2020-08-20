#import <dlfcn.h>
#import <objc/runtime.h>
#import <sys/stat.h>
#import <Social/Social.h>
#import <NSTask.h>
#import <prefs.h>

@interface AZInstallerSetController : PSListController
+ (AZInstallerSetController*)shared;
- (void)setNonceValue:(id)value specifier:(PSSpecifier *)specifier;
- (id)readNonceValue:(PSSpecifier*)specifier;
@end

@interface AZInstallerApp : UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	UIViewController *_viewController;
}
@property (nonatomic, retain) UIWindow *window;
@end

@interface UIProgressHUD : UIView
- (void) showInView:(UIView *)view;
- (void) setText:(NSString *)text;
- (void) done;
- (void) hide;
@end
