//
//  MyModule.h
#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface MyModule : NSObject<RCTBridgeModule>
+(NSMutableDictionary*)refreshItemsWithArray:(NSMutableArray*)array;

@end
