//
//  WNKChatViewController.h
//  Wink
//
//  Created by Usman Khan on 09/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNKFirstViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface WNKChatViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UITextView *chatView;
@property (strong, nonatomic) MCPeerID *chatPeerID;
@property (strong, nonatomic) WNKFirstViewController *parentController;

- (IBAction)sendButtonPressed;
- (IBAction)cancelButtonPressed;
- (IBAction)dismissButtonPressed;

@end
