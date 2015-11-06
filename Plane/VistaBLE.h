//
//  VistaBLE.h
//  Plane
//
//  Created by Victor Rojas on 06/11/15.
//  Copyright © 2015 Victor Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "RFduino.h"

@interface VistaBLE : UIViewController<RFduinoDelegate> {
    CMMotionManager *motionManager;
    //CMAttitude *referenceAttitude;
    NSTimer *timer;
    
    IBOutlet UITextView * debug;
}

@property(strong, nonatomic) RFduino *rfduino;

@end
