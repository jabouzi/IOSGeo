//
//  ViewController.m
//  geolocation
//
//  Created by Skander Jabouzi on 2015-10-27.
//  Copyright © 2015 Skander Software Solutions. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *search;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc]  init];
    [self setLocationManager:_locationManager];
    
    NSLog(@"locationManager: %hhd", [[self locationManager] locationServicesEnabled]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getGeolocation:(id)sender {

    self.locationManager.delegate = self;
    [self locationManager].distanceFilter = kCLDistanceFilterNone;
    [self locationManager].desiredAccuracy = kCLLocationAccuracyBest;
    [[self locationManager] startUpdatingLocation];
    [[self locationManager] requestWhenInUseAuthorization];
    NSLog(@"locationManager: %@", [self locationManager]);
}

- (IBAction)searchLocation:(id)sender {
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        [self longitude].text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        [self latitude].text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

@end
