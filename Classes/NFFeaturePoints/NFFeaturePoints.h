//
//  NFFeaturePoints.h
//
//  Created by William Locke on 3/5/13.
//
//

#import <Foundation/Foundation.h>
//#import "FP.h"

@interface NFFeaturePoints : NSObject

@property (nonatomic, copy) NSString *cdnDomainName;

@property (nonatomic, strong) NSOperationQueue *queue;

+ (NFFeaturePoints *)sharedInstance;

-(void)retrieveAppKeyAndSecret:(void (^ )(NSString *appKey, NSString *appSecret))completionHandler;


@end
