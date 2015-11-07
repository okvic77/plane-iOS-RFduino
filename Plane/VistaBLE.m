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
    bool isOn;
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
    isOn = false;
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
    
    
    if (isOn) {
        float indicador = motionManager.accelerometerData.acceleration.x;
        if (indicador < 0) { // Izquierda
            motorA = 255 - roundf(indicador * 255) * - 1;
            motorB = 255;
        } else {
            motorA = 255;
            motorB = 255 - roundf(indicador * 255);
        }
        
        
        //NSData * datos = [NSData dataWithBytes:<#(nullable const void *)#> length:<#(NSUInteger)#>]
        float atenuacion = 1 - fabs(motionManager.accelerometerData.acceleration.z);
        
        motorA *= atenuacion;
        motorB *= atenuacion;
        
    }else{
        motorA = 0;
        motorB = 0;
    }
    motorA = abs(motorA);
    motorB = abs(motorB);
    
    uint8_t bytes[] = { (uint8_t)motorA, (uint8_t)motorB };
    NSData* data = [NSData dataWithBytes:(void*)&bytes length:2];
    [rfduino send:data];
    [debug setText:[NSString stringWithFormat:@"%i\n%i", motorA, motorB]];
   
    
}

- (IBAction)toogleButtonIO:(id)sender {
    if (isOn) {
        isOn = false;
        [io setTitle:@"Prender" forState:UIControlStateNormal];
    }else{
        isOn = true;
        [io setTitle:@"Apagar" forState:UIControlStateNormal];
    }
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
