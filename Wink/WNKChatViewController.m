//
//  WNKChatViewController.m
//  Wink
//
//  Created by Usman Khan on 09/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import "WNKChatViewController.h"

@interface WNKChatViewController ()

-(void)sendMyMessage;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation WNKChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:) name:@"WNKMCFDidReceiveDataNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Custom methods

- (IBAction)sendButtonPressed
{
    [self sendMyMessage];
}

- (IBAction)cancelButtonPressed
{
    [_messageField resignFirstResponder];
}

- (IBAction)dismissButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMyMessage];
    return YES;
}

#pragma mark - Private method implementation

-(void)sendMyMessage
{
    NSData *dataToSend = [_messageField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    //WNKFirstViewController *parentController = (WNKFirstViewController *)self.parentViewController;
    NSLog(@"Parent controller is: %@", _parentController);
    
    //NSArray *allConnectedPeers = parentController.manager.connectedPeers;
    //NSArray *chatPeers = [[NSArray alloc] initWithObjects:_chatPeerID, nil];
    NSError *error;
    
    /*
    [_parentController.manager.session sendData:dataToSend
                                     toPeers:chatPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"Error Occured: %@", [error localizedDescription]);
    }
     */
    
    NSLog(@"chatPeerID is: %@", _chatPeerID);
    
    if (![_parentController.manager.session sendData:dataToSend toPeers:[[NSArray alloc] initWithObjects:_chatPeerID, nil]  withMode:MCSessionSendDataReliable error:&error])
    {
        NSLog(@"[Error] %@", error);
    }
    
    
    [_chatView setText:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _messageField.text]]];
    [_messageField setText:@""];
    [_messageField resignFirstResponder];
}


-(void)didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    
    //if ([peerID.displayName isEqualToString:_chatPeerID.displayName])
    //{
        NSString *peerDisplayName = peerID.displayName;
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        [_chatView performSelectorOnMainThread:@selector(setText:) withObject:[_chatView.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    //}
}


@end
