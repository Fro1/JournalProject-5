//
//  MapViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 12/1/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface MapViewController : UIViewController<MKMapViewDelegate, MKAnnotation>{
    MKMapView *mapView;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic) float longitude;
@property (readwrite, nonatomic) float latitude;
@property (readwrite, nonatomic) PFGeoPoint *location;
@property (nonatomic, strong) NSString *cityAndState;

@end
