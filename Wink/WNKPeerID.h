//
//  WNKPeerID.h
//  Wink
//
//  Created by Usman Khan on 09/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface WNKPeerID : MCPeerID

@property (strong, nonatomic) NSString *userID;

@end
