//
//  LocationHelper.m
//  Feimang
//
//  Created by Fm_Qf on 15/12/22.
//  Copyright © 2015年 feimang. All rights reserved.
//

#import "LocationHelper.h"

#import "WGS84TOGCJ02.h"
//#import "SVProgressHUD.h"

@implementation LocationHelper
{
    CLLocationManager *_locationManager;
    
    void (^_locationBlcok)(double ,double);
    void (^_stringBlock)(NSString *, NSString *, NSString *, NSString *);
}

+ (LocationHelper *)shareLocationHelper
{
    static LocationHelper *shareLocationHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareLocationHelper = [[self alloc] init];
    });
    return shareLocationHelper;
}
- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)getUserLocationInfomationLoactionBlcok:(void (^)(double, double))locationBlock stringBlock:(void (^)(NSString *, NSString *, NSString *, NSString *))stringBlock enableBlock:(void (^)(void))enableLocation
{
    _locationBlcok = locationBlock;
    _stringBlock = stringBlock;
        
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
//        [SVProgressHUD showInfoWithStatus:@"定位功能未授权"];
    }else {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
}

// 定位权限变更
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager startUpdatingLocation];
    }
}
// 获取位置信息回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        // 停止定位
        [_locationManager stopUpdatingLocation];
        // 获取位置信息
        CLLocation *currenLocation = [locations lastObject];
        // 火星坐标转换
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[currenLocation coordinate]];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        if (_locationBlcok) {
            _locationBlcok (coord.latitude, coord.longitude);
            _locationBlcok = nil;
        }
        
        NSLog(@"old-------%@", currenLocation);
        NSLog(@"new-------%@", newLocation);

        // 地理编码
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (!error && [placemarks count] > 0) {
                NSDictionary *dict = [[placemarks firstObject] addressDictionary];
                
                NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                NSLog(@"str:%@",str);
                /*
                 Country:中国 State:河南省 City:洛阳市 SubLocality:xx县
                 Country:中国 State:北京市 City:北京市市辖区 SubLocality:朝阳区
                 */
                if (self->_stringBlock) {
                    
                    NSString *Country,*Provinces,*City,*Area;
                    if ([dict[@"Country"] isEqual:[NSNull null]]) {
                        Country = @"";
                    }else {
                        Country = dict[@"Country"];
                    }
                    if ([dict[@"State"] isEqual:[NSNull null]]) {
                        Provinces = @"";
                    }else {
                        Provinces = dict[@"State"];
                    }
                    if ([dict[@"City"] isEqual:[NSNull null]]) {
                        City = @"";
                    }else {
                        City = dict[@"City"];
                    }
                    if ([dict[@"SubLocality"] isEqual:[NSNull null]]) {
                        Area = @"";
                    }else {
                        Area = dict[@"SubLocality"];
                    }
                    
                    NSArray *citys = @[@"北京", @"天津", @"上海", @"重庆"];
                    for (NSString *name in citys) {
                        if ([City hasPrefix:name]) {
                            City = @"";
                            break;
                        }
                    }
                    
                    self->_stringBlock (Country, Provinces, City, Area);
                    self->_stringBlock = nil;
                }
            }
            else {
                // 地理编码出错
                NSLog(@"geocoder_Error:%@,errorDescription:%@",error,error.description);
            }
        }];
    }
}


@end
