//
//  WNKFirstViewController.m
//  Wink
//
//  Created by Usman Khan on 03/04/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import "WNKFirstViewController.h"

@interface WNKFirstViewController ()

@end

@implementation WNKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _manager = [[WNKMCFManager alloc] initWithID:[[UIDevice currentDevice] name]  andServiceName:@"WNK-iconchat"];
    _manager.parentController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (void)addNewPeer:(MCPeerID *)peerID;
{
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:([_manager.connectedPeers count]-1) inSection:0], nil];
    
    [_firstTableView beginUpdates];
    [_firstTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_firstTableView endUpdates];
}

- (void)removePeer:(MCPeerID *)peerID
{
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[_manager.connectedPeers indexOfObject:peerID] inSection:0], nil];
    
    // remove the object from connectedPeers array here not in the calling method.
    
    [_firstTableView beginUpdates];
    [_firstTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_firstTableView endUpdates];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Row count: %lu", (unsigned long)[_manager.connectedPeers count]);
    return [_manager.connectedPeers count];
    //NSLog(@"Row count: %d", [_manager.foundedPeers count]);
    //return [_manager.foundedPeers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //MCPeerID *peerID = [_manager.foundedPeers objectAtIndex:indexPath.row];
    MCPeerID *peerID = [_manager.connectedPeers objectAtIndex:indexPath.row];
    cell.textLabel.text = peerID.displayName;
    return cell;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 70.0;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MCPeerID *peerID = [_manager.foundedPeers objectAtIndex:indexPath.row];
    //[_manager.browser invitePeer:peerID toSession:_manager.session withContext:nil timeout:30];
    
    MCPeerID *peerID = [_manager.connectedPeers objectAtIndex:indexPath.row];
    [_manager sendSomeMessageDataTo:peerID];
    
    // The below command immediately deselects the row before the selected state of cell is even displayed.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/


@end
