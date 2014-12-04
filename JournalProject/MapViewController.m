//
//  MapViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 12/1/14.
//
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView, coordinate, cityAndState, longitude, latitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //We need to grab the longitude and latitude from the post and add it to these two variables
    if(self.location){
        longitude = self.location.longitude;
        latitude = self.location.latitude;
    }
    else{
        longitude = -95.360556;
        latitude = 29.7630556;
    }
    //map
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span.longitudeDelta = 1;
    region.span.latitudeDelta = 1;
    [mapView setRegion:region animated:YES];
    
    //Annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    point.coordinate = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];;
    CLGeocoder *geoCoder =[[CLGeocoder alloc] init];
    
    //Reverse geoCoder to get City name. City and State will be a string in variable cityAndState
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0){
            CLPlacemark *topResults = [placemarks objectAtIndex:0];
            
            //MKPointAnnotation *userPoint = [[MKPointAnnotation alloc]init];
            point.coordinate = point.coordinate;
            
            cityAndState =[NSString stringWithFormat:@"%@ , %@ ", topResults.locality, topResults.administrativeArea];
            point.title = cityAndState;
            
            [self.mapView addAnnotation:point];
            
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
