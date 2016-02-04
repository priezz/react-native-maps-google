#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@class RCTEventDispatcher;

/**
 * Declarations of properties which are accasible via the JavaScript API.
 */
@interface PPTGoogleMap: GMSMapView <CLLocationManagerDelegate>

@property (nonatomic, copy) NSDictionary *cameraPosition;
@property (nonatomic) BOOL *showsUserLocation;
@property (nonatomic) BOOL *scrollGestures;
@property (nonatomic) BOOL *zoomGestures;
@property (nonatomic) BOOL *tiltGestures;
@property (nonatomic) BOOL *rotateGestures;
@property (nonatomic) BOOL *consumesGesturesInView;
@property (nonatomic) BOOL *compassButton;
@property (nonatomic) BOOL *myLocationButton;
@property (nonatomic) BOOL *indoorPicker;
@property (nonatomic) BOOL *allowScrollGesturesDuringRotateOrZoom;
@property (nonatomic, copy) NSArray *markers;

@end