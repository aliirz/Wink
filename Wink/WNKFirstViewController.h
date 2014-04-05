//
//  WNKFirstViewController.h
//  Wink
//
//  Created by Usman Khan on 03/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "WNKMCFManager.h"

@interface WNKFirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *firstTableView;
@property (strong, nonatomic) WNKMCFManager *manager;

- (void)addNewPeer:(MCPeerID *)peerID;
- (void)removePeer:(MCPeerID *)peerID;

//- (IBAction)sendMessage;

@end
