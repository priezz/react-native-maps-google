#import "PPTGoogleMapManager.h"

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "PPTGoogleMap.h"
#import "UIView+React.h"
#import "PPTGoogleMapProvider.h"

@implementation PPTGoogleMapManager

RCT_EXPORT_MODULE()

PPTGoogleMap *map;

RCT_EXPORT_METHOD (moveMarkerUpAndDown:(NSDictionary *)marker toPositionY:(float)valueY  animationSpeed:(float)animationSpeed) 
{
    [map moveMarkerUpAndDown:marker toPositionY:[NSNumber numberWithFloat:valueY] animationSpeed:[NSNumber numberWithFloat:animationSpeed]];
}

RCT_EXPORT_METHOD (setApiKey: (NSString *)apiKey)
{
    [PPTGoogleMapProvider provideAPIKey:apiKey];
}

/**
 * Create a new React Native Google Map view and set the view delegate to this class.
 *
 * @return GoogleMap
 */
- (UIView *)view
{
  map = [[PPTGoogleMap alloc] init];
  
  map.delegate = self;
  
  return map;
}

RCT_EXPORT_VIEW_PROPERTY(cameraPosition, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(showsUserLocation, BOOL)
RCT_EXPORT_VIEW_PROPERTY(scrollGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(zoomGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(tiltGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(rotateGestures, BOOL)
RCT_EXPORT_VIEW_PROPERTY(consumesGesturesInView, BOOL)
RCT_EXPORT_VIEW_PROPERTY(compassButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(myLocationButton, BOOL)
RCT_EXPORT_VIEW_PROPERTY(indoorPicker, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowScrollGesturesDuringRotateOrZoom, BOOL)
RCT_EXPORT_VIEW_PROPERTY(cameraMove, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(cameraDirection, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(markers, NSDictionaryArray)

#pragma mark GMSMapViewDelegate

/**
 * Called before the camera on the map changes, either due to a gesture, animation (e.g., by a user tapping on the "My Location" 
 * button) or by being updated explicitly via the camera or a zero-length animation on layer.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
  NSString *type = @"animation";
  
  if (gesture) {
    type = @"gesutre";
  }
  
  NSDictionary *event = @{@"target": mapView.reactTag, @"event": @"willMove", @"type": type};
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called repeatedly during any animations or gestures on the map (or once, if the camera is explicitly set).
 * This may not be called for all intermediate camera positions. It is always called for the final position of an animation or 
 * gesture.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didChangeCameraPosition",
                          @"data": @{
                              @"latitude": [[NSNumber alloc] initWithDouble:position.target.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:position.target.longitude],
                              @"zoom": [[NSNumber alloc] initWithDouble:position.zoom]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called when the map becomes idle, after any outstanding gestures or animations have completed (or after the camera has 
 * been explicitly set).
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"idleAtCameraPosition",
                          @"data": @{
                              @"latitude": [[NSNumber alloc] initWithDouble:position.target.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:position.target.longitude],
                              @"zoom": [[NSNumber alloc] initWithDouble:position.zoom]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called after a tap gesture at a particular coordinate, but only if a marker was not tapped.
 * This is called before deselecting any currently selected marker (the implicit action for tapping on the map).
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didTapAtCoordinate",
                          @"data": @{
                              @"latitude": [[NSNumber alloc] initWithDouble:coordinate.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:coordinate.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called after a long-press gesture at a particular coordinate.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didLongPressAtCoordinate",
                          @"data": @{
                              @"latitude": [[NSNumber alloc] initWithDouble:coordinate.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:coordinate.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called after a marker has been tapped.
 *
 * @return BOOL
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didTapMarker",
                          @"data": @{
                              @"publicId": marker.userData,
                              @"latitude": [[NSNumber alloc] initWithDouble:marker.position.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:marker.position.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
  
  return NO;
}

/**
 * Called after an overlay has been tapped.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
  NSDictionary *event = @{@"target": mapView.reactTag, @"event": @"didTapOverlay"};
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called when dragging has been initiated on a marker.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didTapMarker",
                          @"data": @{
                              @"publicId": marker.userData,
                              @"latitude": [[NSNumber alloc] initWithDouble:marker.position.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:marker.position.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called after dragging of a marker ended.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didTapMarker",
                          @"data": @{
                              @"publicId": marker.userData,
                              @"latitude": [[NSNumber alloc] initWithDouble:marker.position.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:marker.position.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called while a marker is dragged.
 *
 * @return void
 */
- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
  NSDictionary *event = @{
                          @"target": mapView.reactTag,
                          @"event": @"didTapMarker",
                          @"data": @{
                              @"publicId": marker.userData,
                              @"latitude": [[NSNumber alloc] initWithDouble:marker.position.latitude],
                              @"longitude": [[NSNumber alloc] initWithDouble:marker.position.longitude]
                              }
                          };
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
}

/**
 * Called when the My Location button is tapped. Returns YES if the listener has consumed the event (i.e., the default behavior
 * should not occur), NO otherwise (i.e., the default behavior should occur). The default behavior is for the camera to move
 * such that it is centered on the user location.
 *
 * @return BOOL
 */
- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
  NSDictionary *event = @{@"target": mapView.reactTag, @"event": @"didTapMyLocationButtonForMapView"};
  
  [self.bridge.eventDispatcher sendInputEventWithName:@"topChange" body:event];
  
  return NO;
}

@end
