


#pragma mark ----TheThird---------------
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SVProgressHUD/SVProgressHUD.h"


#pragma mark ----Controller---------------

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataManager.h"





#pragma mark ----Anything---------------

//RGB色彩
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//屏幕宽度
#define ScreenWindowWidth                        [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define ScreenWindowHeight                       [[UIScreen mainScreen] bounds].size.height
//加载等待
#define SVProgressWait       [SVProgressHUD showWithStatus:@"加载中，请稍后。。。"]
//加载结束
#define SVProgressStop              [SVProgressHUD dismiss]
//字体加粗
#define JiaCu  @"Helvetica-Bold"
//请求时间
#define waitTime   10.0f;
