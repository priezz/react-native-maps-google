#import <Foundation/NSObject.h>

@interface PPTGoogleMapProvider : NSObject

/**
 * Sets the google maps API key without having to include the Google Maps iOS SDK in the main
 * React project.
 *
 * @return BOOL
 */
+ (BOOL)provideAPIKey:(NSString *)apiKey;

@end
