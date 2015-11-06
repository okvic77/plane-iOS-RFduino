//
//  ListaBLE.m
//  Plane
//
//  Created by Victor Rojas on 06/11/15.
//  Copyright © 2015 Victor Rojas. All rights reserved.
//

#import "ListaBLE.h"

#import "RFduinoManager.h"
#import "RFduino.h"

#import "VistaBLE.h"
@interface ListaBLE () {
    bool loadService;
}

@end

@implementation ListaBLE


- (void)didDiscoverRFduino:(RFduino *)rfduino {
    [self.tableView reloadData];
}

- (void)didUpdateDiscoveredRFduino:(RFduino *)rfduino
{
        [self.tableView reloadData];
}
- (void)didConnectRFduino:(RFduino *)rfduino
{
    NSLog(@"didConnectRFduino");
    
    [rfduinoManager stopScan];
    
    loadService = false;
}

- (void)didLoadServiceRFduino:(RFduino *)rfduino
{
    //AppViewController *viewController = [[AppViewController alloc] init];
    //viewController.rfduino = rfduino;
    NSLog(@"Holas");
    VistaBLE * vista = (VistaBLE*)[[self storyboard] instantiateViewControllerWithIdentifier:@"VistaBLEId"];
    vista.rfduino = rfduino;
    loadService = true;
    [[self navigationController] pushViewController:vista animated:YES];
}

- (void)didDisconnectRFduino:(RFduino *)rfduino
{
    
    if (loadService) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    [rfduinoManager startScan];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    rfduinoManager = [RFduinoManager sharedRFduinoManager];
    rfduinoManager.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[rfduinoManager rfduinos] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListaVistaBLE" forIndexPath:indexPath];
    
    RFduino *rfduino = [rfduinoManager.rfduinos objectAtIndex:[indexPath row]];

    
    
    
    
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@", rfduino.name];
    
    int rssi = rfduino.advertisementRSSI.intValue;
    
    NSString *advertising = @"";
    if (rfduino.advertisementData) {
        advertising = [[NSString alloc] initWithData:rfduino.advertisementData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *detail = [NSMutableString stringWithCapacity:100];
    [detail appendFormat:@"RSSI: %d dBm", rssi];
    while ([detail length] < 25)
        [detail appendString:@" "];
    [detail appendFormat:@"Packets: %ld\n", (long)rfduino.advertisementPackets];
    [detail appendFormat:@"Advertising: %@\n", advertising];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.numberOfLines = 3;

    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show loading indicator
    NSLog(@"clickck");
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSLog(@"Holas a nuevo link");
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFduino *rfduino = [[rfduinoManager rfduinos] objectAtIndex:[indexPath row]];
    
    if (! rfduino.outOfRange) {
        [rfduinoManager connectRFduino:rfduino];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
