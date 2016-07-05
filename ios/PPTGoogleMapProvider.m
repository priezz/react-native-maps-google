#import <Foundation/NSBundle.h>
#import <GoogleMaps/GoogleMaps.h>

#import "PPTGoogleMapProvider.h"

@implementation PPTGoogleMapProvider

/**
 * Sets the google maps API key without having to include the Google Maps iOS SDK in the main
 * React project.
 *
 * @return BOOL
 */
+ (BOOL)provideAPIKey:(NSString *)apiKey {
    
    if(apiKey != nil)
    {
        return [GMSServices provideAPIKey:apiKey];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GoogleMapsApi" ofType:@"plist"]];
    NSString * ApiKey = dictionary[@"API Key"];
    
    if (ApiKey) {
        return [GMSServices provideAPIKey:ApiKey];
    }
    
    return NO;
}

@end
