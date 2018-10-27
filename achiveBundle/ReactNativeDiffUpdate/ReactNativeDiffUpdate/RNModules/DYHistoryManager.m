
#import "DYHistoryManager.h"
#import "DYVideoRoomModel.h"
#import "DYRoomModel.h"
#import "DYUserManger.h"
#import "InterfaceManager.h"
@implementation DYHistoryManager
static DYHistoryManager *historyManager;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        historyManager  = [[DYHistoryManager alloc]init];
    });
    
    return historyManager;
}
-(void)getLiveRoomDatacallback:(LiveDataComplete)callback{
    NSMutableArray* arrayRooms = [[NSMutableArray alloc] init];
    //获取直播本地信息
    NSArray *roomidArr = [UserDefaults objectForKey:LOCALHISORY_ROOMID];
    if (roomidArr && roomidArr.count) {   //是否有本地历史
        NSString *ids = [roomidArr componentsJoinedByString:@","];
        [InterfaceManager getLocalHistoryList:ids completion:^(int errorCode, NSString *errorMessage, id data) {
            if (errorCode == 0) {
                if ([data isKindOfClass:[NSArray class]]) {
                    [arrayRooms addObjectsFromArray:data];
                }
                else if ([data isKindOfClass:[DYRoomModel class]]) {
                    [arrayRooms addObject:data];
                }
            }else if (errorCode == REQUEST_FAIL_CODE){
                
            }
            if ([[DYUserManger shareInstant] isLogin]) {  //登录用户获取网络历史记录
                [InterfaceManager getOnlineHistoryList:^(int errorCode, NSString *errorMessage, id data) {
                    
                    if (errorCode == 0) {
                        NSArray *online = [NSArray arrayWithArray:data];
                        if (online && online.count) {   //排重，避免本地数据和网络数据重复
                            for (DYRoomModel *roomOnline in online) {
                                BOOL isExist = NO;
                                for (DYRoomModel *roomLocal in arrayRooms) {
                                    if ([roomOnline.room_id isEqualToString:roomLocal.room_id]) {
                                        isExist = YES;
                                        break;
                                    }
                                }
                                if (!isExist) {
                                    [arrayRooms addObject:roomOnline];
                                }
                            }
                            
                        }
                    }else{
                        
                    }
                    [self callbackdata:arrayRooms callback:callback];
                    
                    
                }];
            }else{
                [self callbackdata:arrayRooms callback:callback];
            }
        }];
    }else{
        if ([[DYUserManger shareInstant] isLogin]) {
            [InterfaceManager getOnlineHistoryList:^(int errorCode, NSString *errorMessage, id data) {
                if (errorCode == 0) {
                    [arrayRooms addObjectsFromArray:data];
                }
                [self callbackdata:arrayRooms callback:callback];
            }];
        } else {
            [self callbackdata:arrayRooms callback:callback];
        }
    }

}
-(void)getVideoRoomDatacallback:(VideoDataComplete)callback{
    // 点播本地历史记录
    NSMutableArray *videoIdsArray = [UserDefaults objectForKey:LOCAL_HISTORY_VIDEO_ID];
    //是否有本地历史
    NSString *videoIdsString = nil;
    
    if (videoIdsArray && videoIdsArray.count) {
        videoIdsString = [videoIdsArray componentsJoinedByString:@","];
    }
    [InterfaceManager getVodMyHistory:videoIdsString completion:^(int errorCode, NSString *errorMessage, id data) {
        if (errorCode == 0) {
            NSArray *online = [NSArray arrayWithArray:data];
            NSMutableArray* videoArray = [[NSMutableArray alloc]init];
            if (online && online.count) {
                [videoArray addObjectsFromArray:data];
            }
            [self refreshVideoWithArray:videoArray callback:^(NSString *jsonStr) {
                if (callback) {
                    callback(jsonStr);
                }
            }];
        }else if (errorCode == REQUEST_FAIL_CODE){
            
        }
    }];
}

// 点播视频根据时间戳排序
-(void)refreshVideoWithArray:(NSMutableArray*)array callback:(VideoDataComplete)callback{
    
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DYVideoRoomModel *dic1 = obj1;
        DYVideoRoomModel *dic2 = obj2;
        NSDictionary *timeDic = [UserDefaults objectForKey:LOCAL_HISTORY_VIDEO_TIME];
        NSDate *date = [NSDate date];
        NSTimeInterval first = 0;
        if (dic1.h_update_time) {
            first = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[dic1.h_update_time longLongValue]]];
        }else if([UserDefaults objectForKey:LOCAL_HISTORY_VIDEO_TIME]){
            first = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[[timeDic objectForKey:dic1.video_id] longLongValue]]];
        }
        dic1.recordTime = [NSNumber numberWithLong:first];
        NSTimeInterval second = 0;
        if (dic2.h_update_time) {
            second = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[dic2.h_update_time longLongValue]]];
        }else if([UserDefaults objectForKey:LOCAL_HISTORY_VIDEO_TIME]){
            second = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[[timeDic objectForKey:dic2.video_id] longLongValue]]];
        }
        dic2.recordTime = [NSNumber numberWithLong:second];
        if (first > second) {
            return NSOrderedDescending;
        }else if (first == second){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    NSArray*liveStingArray = nil;
    if (array.count>0) {
        liveStingArray = [JSONModel arrayOfDictionariesFromModels:array];
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:liveStingArray forKey:@"data"];
    NSData *datatwo=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:datatwo encoding:NSUTF8StringEncoding];
    if (callback) {
        callback(jsonStr);
    }
}

-(void)refreshItemsWithArray:(NSMutableArray*)array callback:(LiveDataComplete)callback
{
    NSMutableArray *liveArray = [[NSMutableArray alloc] init];
    NSMutableArray *unLiveArray = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DYRoomModel *dic1 = obj1;
        DYRoomModel *dic2 = obj2;
        
        NSDictionary *timeDic = [UserDefaults objectForKey:LOCALHISORY_TIME];
        NSDate *date = [NSDate date];
        NSTimeInterval first = 0;
        if (dic1.lt) {
            first = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[dic1.lt longLongValue]]];
        }else if([UserDefaults objectForKey:LOCALHISORY_TIME]){
            first = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[[timeDic objectForKey:dic1.room_id] longLongValue]]];
        }
        dic1.recordTime = [NSNumber numberWithLong:first];
        NSTimeInterval second = 0;
        if (dic2.lt) {
            second = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[dic2.lt longLongValue]]];
        }else if([UserDefaults objectForKey:LOCALHISORY_TIME]){
            second = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[[timeDic objectForKey:dic2.room_id] longLongValue]]];
        }
        dic2.recordTime = [NSNumber numberWithLong:first];
        if (first > second) {
            return NSOrderedDescending;
        }else if (first == second){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    for (DYRoomModel *model in array ) {
        if ([model.show_status intValue] == 1) {
            [liveArray addObject:model];
        }else{
            [unLiveArray addObject:model];
        }
    }
    
    NSArray*liveSting = nil;
    if (liveArray.count>0) {
        liveSting = [JSONModel arrayOfDictionariesFromModels:liveArray];
        
    }
    NSArray*unliveSting = nil;
    if (unLiveArray.count>0) {
        unliveSting = [JSONModel arrayOfDictionariesFromModels:unLiveArray];
        
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:liveSting forKey:@"data"];
    NSData *dataone=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:dataone encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary2 = [[NSMutableDictionary alloc] init];
    [dictionary2 setValue:unliveSting forKey:@"data"];
    NSData *datatwo=[NSJSONSerialization dataWithJSONObject:dictionary2 options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStrTwo=[[NSString alloc]initWithData:datatwo encoding:NSUTF8StringEncoding];
    if (callback) {
        callback(jsonStr,jsonStrTwo);
    }
}
-(void)callbackdata:(NSMutableArray*)array  callback:(LiveDataComplete)callback{
    [self refreshItemsWithArray:array callback:^(NSString *jsonOneStr, NSString *jsonTwoStr) {
        if (callback) {
            callback(jsonOneStr,jsonTwoStr);
        }
    }];
}
@end
