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
    
    _geocoder = [[CLGeocoder alloc] init];
    [self setGeocoder:_geocoder];
    
    self.locationManager.delegate = self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getGeolocation:(id)sender {

    [self locationManager].distanceFilter = kCLDistanceFilterNone;
    [self locationManager].desiredAccuracy = kCLLocationAccuracyBest;
    [[self locationManager] startUpdatingLocation];
    [[self locationManager] requestWhenInUseAuthorization];
    NSLog(@"locationManager: %@", [self locationManager]);
}

- (IBAction)searchLocation:(id)sender {
     
     [[self geocoder] geocodeAddressString:[[self search] text] completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        [self setPlacemark:_placemark];
        if (error == nil && [placemarks count] > 0) {
            [self setPlacemark:[placemarks lastObject]];
            NSLog(@"%@", [self placemark]);
            [[self latitude] setText:[NSString stringWithFormat:@"%lf", [self placemark].location.coordinate.latitude]];
            [[self longitude] setText:[NSString stringWithFormat:@"%lf", [self placemark].location.coordinate.longitude]];
            [[self city] setText:[[self placemark] locality]];
            [[self country] setText:[[self placemark] country]];
            [[self state] setText:[[self placemark] administrativeArea]];
            [[self address] setText:[NSString stringWithFormat:@" %@ %@ %@", [[self placemark] subThoroughfare], [[self placemark] thoroughfare], [[self placemark] postalCode]]];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
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
        
        [[self latitude] setText:[NSString stringWithFormat:@"%lf", location.coordinate.latitude]];
        [[self longitude] setText:[NSString stringWithFormat:@"%lf", location.coordinate.longitude]];
        
        [[self locationManager] stopUpdatingLocation];
        
        NSLog(@"Resolving the Address");
        [[self geocoder] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            [self setPlacemark:_placemark];
            if (error == nil && [placemarks count] > 0) {
                [self setPlacemark:[placemarks lastObject]];
                NSLog(@"%@", [self placemark]);
                [[self city] setText:[[self placemark] locality]];
                [[self country] setText:[[self placemark] country]];
                [[self state] setText:[[self placemark] administrativeArea]];
                [[self address] setText:[NSString stringWithFormat:@" %@ %@ %@", [[self placemark] subThoroughfare], [[self placemark] thoroughfare], [[self placemark] postalCode]]];
                /*addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                     placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.postalCode, placemark.locality,
                                     placemark.administrativeArea,
                                     placemark.country];*/
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];

    }
}

/*- (void)geocodeAddressString:(NSString *)addressString
           completionHandler:(CLGeocodeCompletionHandler)completionHandler
{
    
}*/

@end
