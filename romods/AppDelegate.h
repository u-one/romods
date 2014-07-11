//
//  AppDelegate.h
//  romods
//
//  Created by Kosuke Nagano on 2014/07/11.
//  Copyright (c) 2014年 Kousuke Nagano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaHTTPServer/HTTPServer.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 HTTPサーバーインスタンス
 */
@property (strong, nonatomic) HTTPServer *httpServer;


@end

