//
//  NFFeaturePoints.m
//
//  Created by William Locke on 3/5/13.
//
//

#import "NFFeaturePoints.h"
#import "NFWebApiClient.h"

@interface NFFeaturePoints(){
    NFWebApiClient *_webApiClient;
}
@end

@implementation NFFeaturePoints

+ (NFFeaturePoints *)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cdnDomainName = @"s3.amazonaws.com/cdn.ninjafish.com";
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:10];
        
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleExecutable"]];
        bundleName = [bundleName lowercaseString];
        NSString *urlString = [@"" stringByAppendingFormat:@"http://%@/%@/keys/", _cdnDomainName, bundleName];
        _webApiClient = [[NFWebApiClient alloc] initWithBaseUrl:urlString];
        
    }
    return self;
}



-(void)retrieveAppKeyAndSecret:(void (^ )(NSString *appKey, NSString *appSecret))completionHandler{
    
    [_webApiClient webApiCall:@"featurepoints.json" params:nil files:nil httpMethod:nil options:nil NFWebApiResponseHandler:^(id<NFWebApiResponse> webApiResponse){

        
        @try {
            if([[webApiResponse data] items] && [[webApiResponse data] items].count > 0){
                NSDictionary *appInfo = [[[webApiResponse data] items] objectAtIndex:0];
                NSString *appKey = [appInfo objectForKey:@"appKey"];
                NSString *appSecret = [appInfo objectForKey:@"appSecret"];
                completionHandler(appKey, appSecret);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error loading feature points app info");
        }
        @finally {
            
        }
    }];
}






@end
