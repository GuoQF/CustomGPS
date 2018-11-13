//
//  LocationHelper.h
//  Feimang
//
//  Created by Fm_Qf on 15/12/22.
//  Copyright © 2015年 feimang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject <CLLocationManagerDelegate>

/**
 *  单例
 *
 *  @return LocationHelper *
 */
+ (LocationHelper *)shareLocationHelper;

/**
 *  获取用户位置信息
 *
 *  @param locationBlock 用户位置 经纬度回调
 *  @param stringBlock   用户位置 省市区回调
 */
- (void)getUserLocationInfomationLoactionBlcok:(void (^)(double latitude, double longitude))locationBlock stringBlock:(void (^)(NSString *country, NSString *province, NSString *city,NSString *area))stringBlock enableBlock:(void(^)(void))enableLocation;

@end
