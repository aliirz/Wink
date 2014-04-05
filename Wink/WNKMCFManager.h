//
//  WNKMCFManager.h
//  Wink
//
//  Created by Usman Khan on 05/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@class WNKFirstViewController;

@interface WNKMCFManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate,MCSessionDelegate>

@property (strong, nonatomic) MCPeerID *myPeerID;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) NSMutableArray *connectedPeers;
@property (strong, nonatomic) NSMutableArray *foundedPeers;
@property (nonatomic) WNKFirstViewController *parentController;

- (id)initWithID:(NSString *)uid andServiceName:(NSString *)servName;
//- (void)presentBrowser;
- (void)sendSomeMessageDataTo:(MCPeerID *)peerID;

@end
