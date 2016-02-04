#import "PPTGoogleMap.h"

#import "RCTConvert.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "RCTUtils.h"

@implementation PPTGoogleMap {
    NSMutableDictionary *markerImages;
    CLLocationManager *locationManager;
    float zoom;
}

/**
 * Init the google map view class.
 *
 * @return id
 */
- (id)init
{
    if (self = [super init]) {
        markerImages = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

/**
 * Enables layout sub-views which are required to render a non-blank map.
 *
 * @return void
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect mapFrame = self.frame;
    
    self.frame = CGRectZero;
    self.frame = mapFrame;
}

#pragma mark Accessors

/**
 * Sets the map camera position.
 *
 * @return void
 */
- (void)setCameraPosition:(NSDictionary *)cameraPosition
{
    zoom = ((NSNumber*)cameraPosition[@"zoom"]).doubleValue;
    
    if (cameraPosition[@"zoom"]) {
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
    } else {
        CLLocationDegrees latitude = ((NSNumber*)cameraPosition[@"latitude"]).doubleValue;
        CLLocationDegrees longitude = ((NSNumber*)cameraPosition[@"longitude"]).doubleValue;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                                longitude:longitude
                                                                     zoom:zoom];
        
        [self setCamera: camera];
    }
}

/**
 * The delegate for the did update location event - fired when the user's location becomes available and then centers the
 * map about the their location. The location manager is then stopped so that the map position doesn't continue to be updated.
 *
 * @return void
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:zoom];
    
    
    [self setCamera: camera];
    
    [locationManager stopUpdatingLocation];
}

/**
 * Adds marker icons to the map.
 *
 * @return void
 */
- (void)setMarkers:(NSArray *)markers
{
    [self clear];
    
    for (NSDictionary* marker in markers) {
        NSString *publicId = marker[@"publicId"];
        CLLocationDegrees latitude = ((NSNumber*)marker[@"latitude"]).doubleValue;
        CLLocationDegrees longitude = ((NSNumber*)marker[@"longitude"]).doubleValue;
        
        GMSMarker* mapMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(latitude, longitude)];
        
        if (marker[@"icon"]) {
            mapMarker.icon = [self getMarkerImage:marker];
        } else if (marker[@"hexColor"]) {
            UIColor *color = [self getMarkerColor:marker];
            mapMarker.icon = [GMSMarker markerImageWithColor:color];
        }
        
        mapMarker.userData = publicId;
        mapMarker.map = self;
    }
}

/**
 * Get a UIColor from the marker's 'color' string
 *
 * @return UIColor
 */
- (UIColor *)getMarkerColor:(NSDictionary *)marker
{
    NSString *hexString = marker[@"hexColor"];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:0.8];
}

/**
 * Load the marker image or use one that's already been loaded.
 *
 * @return NSImage
 */
- (UIImage *)getMarkerImage:(NSDictionary *)marker
{
    NSString *markerPath = marker[@"icon"][@"uri"];
    CGFloat markerScale = ((NSNumber*)marker[@"icon"][@"scale"]).doubleValue;
    
    if (!markerImages[markerPath]) {
        UIImage *markerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:markerPath]]];
        
        UIImage *markerScaled = [UIImage imageWithCGImage:[markerImage CGImage]
                                                    scale:(markerScale)
                                              orientation:(markerImage.imageOrientation)];
        
        [markerImages setObject:markerScaled forKey:markerPath];
    }
    
    
    return markerImages[markerPath];
}

/**
 * Sets the user's location marker, if it has been enabled. Don't be alarmed if the marker looks funny when testing the app in
 * the simulator, there's a known bug: https://code.google.com/p/gmaps-api-issues/issues/detail?id=5472
 *
 * @return void
 */
- (void)setShowsUserLocation:(BOOL *)showsUserLocation
{
    if (showsUserLocation) {
        self.myLocationEnabled = YES;
    } else {
        self.myLocationEnabled = NO;
    }
}

/**
 * Controls whether scroll gestures are enabled (default) or disabled.
 *
 * @return void
 */
- (void)setScrollGestures:(BOOL *)scrollGestures
{
    if (scrollGestures) {
        self.settings.scrollGestures = YES;
    } else {
        self.settings.scrollGestures = NO;
    }
}

/**
 * Controls whether zoom gestures are enabled (default) or disabled.
 *
 * @return void
 */
- (void)setZoomGestures:(BOOL *)zoomGestures
{
    if (zoomGestures) {
        self.settings.zoomGestures = YES;
    } else {
        self.settings.zoomGestures = NO;
    }
}

/**
 * Controls whether tilt gestures are enabled (default) or disabled.
 *
 * @return void
 */
- (void)setTiltGestures:(BOOL *)tiltGestures
{
    if (tiltGestures) {
        self.settings.tiltGestures = YES;
    } else {
        self.settings.tiltGestures = NO;
    }
}

/**
 * Controls whether rotate gestures are enabled (default) or disabled.
 *
 * @return void
 */
- (void)setRotateGestures:(BOOL *)rotateGestures
{
    if (rotateGestures) {
        self.settings.rotateGestures = YES;
    } else {
        self.settings.rotateGestures = NO;
    }
}

/**
 * Controls whether gestures by users are completely consumed by the GMSMapView when gestures are enabled (default YES).
 *
 * @return void
 */
- (void)setConsumesGesturesInView:(BOOL *)consumesGesturesInView
{
    if (consumesGesturesInView) {
        self.settings.consumesGesturesInView = YES;
    } else {
        self.settings.consumesGesturesInView = NO;
    }
}

/**
 * Enables or disables the compass.
 *
 * @return void
 */
- (void)setCompassButton:(BOOL *)compassButton
{
    if (compassButton) {
        self.settings.compassButton = YES;
    } else {
        self.settings.compassButton = NO;
    }
}

/**
 * Enables or disables the My Location button.
 *
 * @return void
 */
- (void)setMyLocationButton:(BOOL *)myLocationButton
{
    if (myLocationButton) {
        self.settings.myLocationButton = YES;
    } else {
        self.settings.myLocationButton = NO;
    }
}

/**
 * Enables (default) or disables the indoor floor picker.
 *
 * @return void
 */
- (void)setIndoorPicker:(BOOL *)indoorPicker
{
    if (indoorPicker) {
        self.settings.indoorPicker = YES;
    } else {
        self.settings.indoorPicker = NO;
    }
}

/**
 * Controls whether rotate and zoom gestures can be performed off-center and scrolled around (default YES).
 *
 * @return void
 */
- (void)setAllowScrollGesturesDuringRotateOrZoom:(BOOL *)allowScrollGesturesDuringRotateOrZoom
{
    if (allowScrollGesturesDuringRotateOrZoom) {
        self.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    } else {
        self.settings.allowScrollGesturesDuringRotateOrZoom = NO;
    }
}

@end