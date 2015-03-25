//
//  MyHTTPConnection.m
//  HttpRomo
//
//  Created by Yuichi Watanabe on 2015/03/20.
//  Copyright (c) 2015年 ACCESS CO.,LTD. All rights reserved.
//

#import "MyHttpConnection.h"
#import "HTTPMessage.h"
#import "HTTPResponse.h"
#import "HTTPDynamicFileResponse.h"
#import "GCDAsyncSocket.h"
#import "MyWebSocket.h"
#import "HTTPLogging.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;

@implementation MyHttpConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    HTTPLogTrace();
    
    if ([path isEqualToString:@"/WebSocketTest2.js"])
    {
        NSString *wsLocation;
        NSString *wsHost = [request headerField:@"Host"];
        if (wsHost == nil)
        {
            NSString *port = [NSString stringWithFormat:@"%hu", [asyncSocket localPort]];
            wsLocation = [NSString stringWithFormat:@"ws://localhost:%@/service", port];
        }
        else
        {
            wsLocation = [NSString stringWithFormat:@"ws://%@/service", wsHost];
        }

        NSDictionary *replacementDict = [NSDictionary dictionaryWithObject:wsLocation forKey:@"WEBSOCKET_URL"];
        
        return [[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path]
                                                   forConnection:self
                                                       separator:@"%%"
                                           replacementDictionary:replacementDict];

    }
    
    return [super httpResponseForMethod:method URI:path];
}

- (WebSocket *)webSocketForURI:(NSString *)path
{
    HTTPLogTrace2(@"%@[%p]: webSocketForURI: %@", THIS_FILE, self, path);
    
    if ([path isEqualToString:@"/service"])
    {
        HTTPLogInfo(@"MyHTTPConnection: Creating MyWebSocket...");
        
        return [[MyWebSocket alloc] initWithRequest:request socket:asyncSocket];
    }
    return [super webSocketForURI:path];
}

@end
