//
//  VistaBLE.m
//  Plane
//
//  Created by Victor Rojas on 06/11/15.
//  Copyright © 2015 Victor Rojas. All rights reserved.
//

#import "VistaBLE.h"

@interface VistaBLE () {
    int motorA;
    int motorB;
}

@end

@implementation VistaBLE {
    int packets;
    char ch;
    int packet;
    double start;
}

@synthesize rfduino;

- (void)viewDidLoad {
    [super viewDidLoad];
    [rfduino setDelegate:self];
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startAccelerometerUpdates];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(doGyroUpdate)
                                           userInfo:nil 
                                            repeats:YES];
    packets = 500;
    ch = 'A';
    packet = 0;
}

-(void)doGyroUpdate {
    //float ratex = motionManager.gyroData.rotationRate.x;
    //float ratey = motionManager.gyroData.rotationRate.y;
    //float ratez = motionManager.gyroData.rotationRate.z;
    float indicador = motionManager.accelerometerData.acceleration.x;
    
    
    if (indicador < 0) { // Izquierda
        motorA = 255 - roundf(indicador * 255) * - 1;
        motorB = 255;
    } else {
        motorA = 255;
        motorB = 255 - roundf(indicador * 255);
    }
    //[rfduino send:NSDa]
    //float ratey = motionManager.accelerometerData.acceleration.y;
    //float ratez = motionManager.accelerometerData.acceleration.z;
    [debug setText:[NSString stringWithFormat:@"%i\n%i\n%f", motorA, motorB, indicador]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];
    [motionManager stopGyroUpdates];
    [rfduino disconnect];
    NSLog(@"Bye");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
