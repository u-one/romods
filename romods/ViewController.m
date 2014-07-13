//
//  ViewController.m
//  romods
//
//  Created by Kosuke Nagano on 2014/07/11.
//  Copyright (c) 2014年 Kousuke Nagano. All rights reserved.
//

#import "ViewController.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize debugText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.viewController = self;
    
    [self getIPAddress];
    
    // To receive messages when Robots connect & disconnect, set RMCore's delegate to self
    [RMCore setDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)robotDidConnect:(RMCoreRobot *)robot
{
    if (robot.isDrivable && robot.isHeadTiltable && robot.isLEDEquipped) {
        self.debugText.text = @"connected!";
        self.Romo = (RMCoreRobot<HeadTiltProtocol, DriveProtocol, LEDProtocol> *) robot;
    }
}

- (void)robotDidDisconnect:(RMCoreRobot *)robot
{
    if (robot == self.Romo) {
        self.Romo = nil;
        self.debugText.text = @"disconnected!";
    }
}

#pragma mark - Actions
- (IBAction)pushLEDBtn:(id)sender
{
    [self blinkLED];
}

- (IBAction)pushTiltBtn:(id)sender
{
    [self headTilt];
}

#pragma mark - IPAddress mehtods

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"ipaddress:%@:%d", address, SERVER_PORT);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 200, 50);
    label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    label.text = [NSString stringWithFormat:@"IPAddress:%@:%d", address, SERVER_PORT];
    [self.view addSubview:label];
    
    return address;
    
}

#pragma mark - Action mehtods
- (void)blinkLED {
    [self.Romo.LEDs blinkWithPeriod:0.5 dutyCycle:0.1];
}

- (void)headTilt {
    // HeadTilt
    if (self.Romo.headAngle < self.Romo.maximumHeadTiltAngle - 1) {
        [self.Romo tiltToAngle:self.Romo.maximumHeadTiltAngle completion:nil];
    } else {
        [self.Romo tiltToAngle:self.Romo.minimumHeadTiltAngle completion:nil];
    }
}

- (void)goForward {
    if ([self.Romo isDriving]) {
        [self.Romo stopDriving];
    }
    [self.Romo driveForwardWithSpeed:1.0];
}
- (void)goBackward {
    if ([self.Romo isDriving]) {
        [self.Romo stopDriving];
    }
    [self.Romo driveBackwardWithSpeed:0.5];
}

- (void)stop {
    [self.Romo stopDriving];
}

@end
