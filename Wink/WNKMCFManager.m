//
//  WNKMCFManager.m
//  Wink
//
//  Created by Usman Khan on 05/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import "WNKMCFManager.h"
#import "WNKFirstViewController.h"

@interface WNKMCFManager ()

- (void)createID:(NSString *)uid;
- (void)createServiceName:(NSString *)name;

@end

@implementation WNKMCFManager

- (id)initWithID:(NSString *)uid andServiceName:(NSString *)servName
{
    self = [super init];
    if (self)
    {
        // Custom Initialization.
        [self createID:uid];
        [self createServiceName:servName];
        _connectedPeers = [[NSMutableArray alloc] init];
        _foundedPeers = [[NSMutableArray alloc] init];
        
        // Initializing and starting advertiser.
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_myPeerID
                                                        discoveryInfo:nil
                                                          serviceType:_serviceName];
        _advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
        
        // Initializing and starting browser.
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_myPeerID serviceType:_serviceName];
        _browser.delegate = self;
        [_browser startBrowsingForPeers];
        
        // Initializing the session.
        _session = [[MCSession alloc] initWithPeer:_myPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
    }
    return self;
}

- (void)createID:(NSString *)uid
{
    //MCPeerID *localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    _myPeerID = [[MCPeerID alloc] initWithDisplayName:uid];
}

- (void)createServiceName:(NSString *)name
{
    _serviceName = name;
}

- (void)sendSomeMessageDataTo:(MCPeerID *)peerID
{
    NSString *message = [NSString stringWithFormat:@"Hello! From Yours Truly %@.", _myPeerID.displayName];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (![_session sendData:data toPeers:[[NSArray alloc] initWithObjects:peerID, nil]  withMode:MCSessionSendDataReliable error:&error])
    {
        NSLog(@"[Error] %@", error);
    }
    
    //dispatch_async(dispatch_get_main_queue(), ^{[_parentController.sentLabel setText:message];});
}

/*
- (void)presentBrowser
{
    _browserViewController = [[MCBrowserViewController alloc] initWithBrowser:_browser
                                                                      session:_session];
    _browserViewController.delegate = self;
}
*/
    
#pragma mark - MCNearbyServiceAdvertiserDelegate Methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Advertising error occured: %@", error.description);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertise didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, _session);
    //[self sendSomeMessageDataTo:peerID];
}

#pragma mark - MCNearbyServiceBrowserDelegate Methods

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Browsing error occured: %@", error.description);
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    if (![_foundedPeers containsObject:peerID])
    {
        [_foundedPeers addObject:peerID];
    }
    
    // Generate random time interval before sending an invite. (in milliseconds)

    /*
    int time = (arc4random_uniform(30))+1; //Generates Number from 1 to 30.
    //sleep(number/100);
    double timeInMS = (time/1000);
    NSLog(@"Sleep time is: %f", timeInMS);
    [NSThread sleepForTimeInterval:time];
     */
    
    [browser invitePeer:peerID toSession:_session withContext:nil timeout:30];
    //[_parentController.firstTableView reloadData];
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    [_foundedPeers removeObject:peerID];
    //[_parentController.firstTableView reloadData];
}

#pragma mark - MCSessionDelegate Methods

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    //NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Message received: %@", message);
    
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WNKMCFDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
    
    //dispatch_async(dispatch_get_main_queue(), ^{[_parentController.receivedLabel setText:message];});
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected)
    {
        NSLog(@"Connected to %@.", peerID);
        if (![_connectedPeers containsObject:peerID])
        {
            [_connectedPeers addObject:peerID];
        }
        //[_parentController addNewPeer:peerID];
        
        [_parentController.firstTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //[_parentController.firstTableView reloadData];
    }
    else if (state == MCSessionStateNotConnected)
    {
        NSLog(@"Disconnected from %@.", peerID);
        [_connectedPeers removeObject:peerID];
        //[_parentController removePeer:peerID];
        
        [_parentController.firstTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //[_parentController.firstTableView reloadData];
    }
    else
    {
        NSLog(@"Connecting to %@.", peerID);
    }
}

/*
#pragma mark - MCBrowserViewControllerDelegate Methods

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [_peers addObject:peerID];
    return YES;
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [_parentController dismissBrowser];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
  [_parentController dismissBrowser];
}
*/

@end

