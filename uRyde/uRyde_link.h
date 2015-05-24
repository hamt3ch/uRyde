#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Sinch/Sinch.h>

@interface uRyde_link : UIResponder <UIApplicationDelegate, SINClientDelegate, SINMessageClientDelegate>

@property (strong, nonatomic) id<SINClient> sinchClient;

- (void)initSinchClient:(NSString*)userId;

@end