//
//  ViewController.m
//  CustomGPS
//
//  Created by Glodon-GQF on 2018/10/23.
//  Copyright © 2018年 Glodon-GQF. All rights reserved.
//

#import "ViewController.h"

#import "LocationHelp/LocationHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[LocationHelper shareLocationHelper] getUserLocationInfomationLocationBlcok:^(double latitude, double longitude) {
        NSLog(@"lotitude:%f longitude:%f",latitude,longitude);
    } stringBlock:^(NSString *FormattedAddressLines) {
        NSLog(@"FormattedAddressLines:%@",FormattedAddressLines);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GPX" message:FormattedAddressLines preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } enableBlock:nil];
}


@end
