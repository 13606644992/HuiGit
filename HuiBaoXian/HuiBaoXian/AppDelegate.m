//
//  AppDelegate.m
//  HuiBaoXian
//
//  Created by  admin on 2016/11/15.
//  Copyright © 2016年 baobao. All rights reserved.
//

#import "AppDelegate.h"
#import "UPPaymentControl.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WXApi registerApp:@"微信ID" withDescription:@"demo 2.0"];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ----------after-iOS9.0-Callback-------
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    NSLog(@"url----%@-------url_absolutesting----------%@",url,[url absoluteString]);
    if([[url absoluteString] hasPrefix:@"UPPayDemo"]){
        //        NSLog(@"******************************************");
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            NSLog(@"code---%@>>>>data>>>>%@",code,data);
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                 //数据从NSDictionary转换为NSString
                 NSDictionary *data;
                 NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
                 NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                 //判断签名数据是否存在
                 if(data == nil){
                 //如果没有签名数据，建议商户app后台查询交易结果
                 return;
                 }
                 //验签证书同后台验签证书
                 //此处的verify，商户需送去商户后台做验签
                 if([self verify:sign]) {
                 //支付成功且验签成功，展示支付成功提示
                 }
                 else {
                 //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                 }
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                NSLog(@"--交易失败");
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                NSLog(@"--交易取消");
            }
        }];
    }else if ([url.host isEqualToString:@"safepay"]){
        NSLog(@"--支付宝交易结果");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else {
        NSLog(@"--微信交易结果");

        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
#pragma mark ----------before-iOS9.0-Callback-------

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //    NSString *string =[url absoluteString];
    NSLog(@"url----%@-------url_absolutesting----------%@",url,[url absoluteString]);
    if([[url absoluteString] hasPrefix:@"UPPayDemo"]){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            NSLog(@"code---%@>>>>data>>>>%@",code,data);
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                 //数据从NSDictionary转换为NSString
                 NSDictionary *data;
                 NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
                 NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                 //判断签名数据是否存在
                 if(data == nil){
                 //如果没有签名数据，建议商户app后台查询交易结果
                 return;
                 }
                 //验签证书同后台验签证书
                 //此处的verify，商户需送去商户后台做验签
                 if([self verify:sign]) {
                 //支付成功且验签成功，展示支付成功提示
                 }
                 else {
                 //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                 }                
                
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                NSLog(@"--交易失败");
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                NSLog(@"--交易取消");
            }
        }];
        
    }else if ([url.host isEqualToString:@"safepay"]){
        NSLog(@"--支付宝交易结果");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else {
        NSLog(@"--微信交易结果");

        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签

    
    return NO;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark ----------微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的-------
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}
@end
