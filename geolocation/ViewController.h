//
//  ViewController.h
//  geolocation
//
//  Created by Skander Jabouzi on 2015-10-27.
//  Copyright © 2015 Skander Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
}

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLGeocoder *geocoder;
@property(nonatomic,retain) CLPlacemark *placemark;

@end

