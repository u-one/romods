//
//  MyWebSocket.m
//  HttpRomo
//
//  Created by Yuichi Watanabe on 2015/03/20.
//  Copyright (c) 2015年 ACCESS CO.,LTD. All rights reserved.
//

#import "MyWebSocket.h"
#import "HTTPLogging.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;

@implementation MyWebSocket

- (void)didOpen
{
    HTTPLogTrace();
    [super didOpen];
    [self sendMessage:@"Welcome to my WebSocket"];
}

- (void)didReceiveMessage:(NSString *)msg
{
    HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
    [self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
}

- (void)didClose
{
    HTTPLogTrace();
    [super didClose];
}

@end
