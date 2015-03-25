//
//  MyHTTPConnection.h
//  HttpRomo
//
//  Created by Yuichi Watanabe on 2015/03/20.
//  Copyright (c) 2015年 ACCESS CO.,LTD. All rights reserved.
//

#ifndef HttpRomo_MyHTTPConnection_h
#define HttpRomo_MyHTTPConnection_h


#import "HttpConnection.h"

@class MyWebSocket;

@interface MyHttpConnection : HTTPConnection
{
    MyWebSocket *ws;
}

@end

#endif
