#import "AZInstallerApp.h"


@implementation AZInstallerApp
@synthesize window = _window;
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
_viewController = [[UINavigationController alloc] initWithRootViewController:[AZInstallerSetController shared]];
[_window addSubview:_viewController.view];
_window.rootViewController = _viewController;
[_window makeKeyAndVisible];
}
@end

__attribute__((constructor))
int main(int argc, char **argv)
{
setgid(0);
setuid(0);
@autoreleasepool {
return UIApplicationMain(argc, argv, @"AZInstallerApp", @"AZInstallerApp");
}
}



@implementation NSString (azflibrary)
- (NSString*)runAsCommand
{
NSPipe* pipe = [NSPipe pipe];
NSTask* task = [[NSTask alloc] init];
[task setLaunchPath: @"/bin/sh"];
[task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
[task setStandardOutput:pipe];
NSFileHandle* file = [pipe fileHandleForReading];
[task launch];
return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}
@end




static __strong AZInstallerSetController* AZInstallerSetControllerCC;
@implementation AZInstallerSetController
+ (AZInstallerSetController*)shared
{
if(!AZInstallerSetControllerCC) {
AZInstallerSetControllerCC = [[[self class] alloc] init];
}
return AZInstallerSetControllerCC;
}
- (id)specifiers {
if (!_specifiers) {
NSMutableArray* specifiers = [NSMutableArray array];
PSSpecifier* spec;



spec = [PSSpecifier preferenceSpecifierNamed:@"Install from URL"
  target:self
			  set:Nil
			  get:Nil
detail:Nil
			  cell:PSGroupCell
			  edit:Nil];
[spec setProperty:@"Install" forKey:@"label"];
[spec setProperty:@"You can install file ipa like (http://location/ipa/azinstaller.ipa)" forKey:@"footerText"];
[specifiers addObject:spec];
spec = [PSSpecifier preferenceSpecifierNamed:@"Install"
target:self
set:NULL
get:NULL
detail:Nil
cell:PSButtonCell
edit:Nil];
spec->action = @selector(azfinstallerURL);
[specifiers addObject:spec];




spec = [PSSpecifier emptyGroupSpecifier];
[spec setProperty:@"AZinstaller © 2020 Azozz ALFiras" forKey:@"footerText"];
[specifiers addObject:spec];
_specifiers = [specifiers copy];
}
return _specifiers;
}

- (void)refresh:(UIRefreshControl *)refresh
{
[self reloadSpecifiers];
if(refresh) {
[refresh endRefreshing];
}
}
- (void)showErrorFormat
{
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:@"Nonce has wrong format.\n\nFormat accept:\n0xabcdef1234567890" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
[alert show];
}
- (void)setNonceValue:(id)value specifier:(PSSpecifier *)specifier
{
@autoreleasepool {
if(value&&[value length]>0) {
value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSError *error = NULL;
NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"0x[0-9a-f]{%@}", @([value length]-2)] options:0 error:&error];
NSUInteger numberOfMatches = [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])];
if(!error && numberOfMatches > 0) {
NSString* comd = [[NSString stringWithFormat:@"nvram com.apple.System.boot-nonce=%@", value] runAsCommand];
NSString* nonce = [self readNonceValue:nil];
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:[NSString stringWithFormat:(comd&&nonce&&[value isEqualToString:nonce])?@"Nonce (%@) has been successfully set.":@"Error in set Nonce (%@).", value] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
[alert show];
} else {
[self showErrorFormat];
}
} else {
[self showErrorFormat];
}
[self refresh:nil];
}
}
- (id)readValue:(PSSpecifier*)specifier
{
return nil;
}
- (id)readNonceValue:(PSSpecifier*)specifier
{
@autoreleasepool {
NSString* comd = [@"nvram com.apple.System.boot-nonce" runAsCommand];
if(comd) {
NSRange firstR = [comd rangeOfString:@"com.apple.System.boot-nonce"];
if(NSNotFound != firstR.location) {
comd = [comd stringByReplacingCharactersInRange:firstR withString:@""];
}
comd = [comd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
return comd;
}
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
@autoreleasepool {

NSString* nonce = [self readNonceValue:nil];
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:([nonce length] < 2)?@"AZinstaller has been deleted successfully.":@"Error in delete Nonce." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
[alert show];
[self refresh:nil];
}
}



- (void) loadView
{
[super loadView];
self.title = @"AZinstaller";
static __strong UIRefreshControl *refreshControl;
if(!refreshControl) {
refreshControl = [[UIRefreshControl alloc] init];
[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
refreshControl.tag = 8654;
}
if(UITableView* tableV = (UITableView *)object_getIvar(self, class_getInstanceVariable([self class], "_table"))) {
if(UIView* rem = [tableV viewWithTag:8654]) {
[rem removeFromSuperview];
}
[tableV addSubview:refreshControl];
}
}

- (void)azfinstallerURL{
@try {

UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.title
message:@"Enter your url ipa"
preferredStyle:UIAlertControllerStyleAlert];
[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
textField.placeholder = @"http://location/ipa/azinstaller.ipa";
@try {
//textField.textColor = [UIColor labelColor];
}@catch(NSException*e){
}
textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//textField.borderStyle = UITextBorderStyleRoundedRect;
}];
[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {


}]];

[alertController addAction:[UIAlertAction actionWithTitle:@"Install File" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

NSArray * textfields = alertController.textFields;
UITextField * URLIpa = textfields[0];
NSString *GetURL = URLIpa.text;

// this link server if you want api sent tell me +9647719675127
NSString *URLStatus = @"https://location/Check.php";
// To get the text that the user entered
// ?URL= doesn't chanage if you want chanage need to edit on Check.php
NSString *apiWithUdid = [NSString stringWithFormat:@"?URL=%@", GetURL];

NSString *FinishedURL = [URLStatus stringByAppendingString:apiWithUdid];
NSError *error;
NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:FinishedURL]]?:[NSData data];
NSMutableDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]?:@{};
// Status for allow the server to signe app or NO,
NSString* Status = jsonResp[@"Status"];

// for get link file plist's for server after (Signed)
NSString* azfURL = jsonResp[@"azfURL"];

// you can chanage this if you want to NO but Will stop from Check.php
if([Status isEqualToString:@"Yes"]){

// will get link app from server and open on app for install
// get from / *azfURL */
[[UIApplication sharedApplication] openURL: [NSURL URLWithString:azfURL]];
} else {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:@"Hi, the server have problem, pls try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
[alert show];
}
}]];

[self presentViewController:alertController animated:YES completion:nil];



} @catch (NSException * e) {
}
}
- (void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:animated];
[self refresh:nil];
}

@end
