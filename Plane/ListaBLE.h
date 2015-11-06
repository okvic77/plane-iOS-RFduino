//
//  ListaBLE.h
//  Plane
//
//  Created by Victor Rojas on 06/11/15.
//  Copyright © 2015 Victor Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RFduinoManagerDelegate.h"

@class RFduinoManager;
@class RFduino;


@interface ListaBLE : UITableViewController<RFduinoManagerDelegate, UITableViewDelegate> {
    RFduinoManager *rfduinoManager;
}

@end
