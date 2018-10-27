
#import <Foundation/Foundation.h>
typedef void(^VideoDataComplete)(NSString *jsonStr);
typedef void(^LiveDataComplete)(NSString *jsonOneStr,NSString *jsonTwoStr);

@interface DYHistoryManager : NSObject

+(instancetype)shareInstance;
-(void)getLiveRoomDatacallback:(LiveDataComplete)callback;
-(void)getVideoRoomDatacallback:(VideoDataComplete)callback;

@end
