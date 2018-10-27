//
//  OCNativeEvent.h
//  RN2NativeDemo


#import "RCTEventEmitter.h"

@interface OCNativeEvent : RCTEventEmitter<RCTBridgeModule>

+(void)popViewControllerCallback;

@end
