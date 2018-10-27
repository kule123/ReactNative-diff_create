
#import "DYRnNetworkModule.h"
#import "InterfaceManager.h"
#import "DYOthersContributeViewController.h"
#import "DYNewAttentionModel.h"
#import "DYTabBarManager.h"
#import "DYVideoViewController.h"

@implementation DYRnNetworkModule

RCT_EXPORT_MODULE();

//获取我的关注列表

RCT_EXPORT_METHOD(myFollowListCallbackEvent:(NSString *)event page:(NSInteger)page callback:(RCTResponseSenderBlock)callback){
    
    [InterfaceManager rn_getNewFollowListWithPage:page completion:^(int errorCode, NSString *errorMessage, id data) {
        if(errorCode == 0){
            if([data isKindOfClass:[NSArray class]]){
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                [dictionary setValue:data forKey:@"data"];
                NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                callback(@[[NSNull null],jsonStr]);
            }
        }
    }];
}


RCT_EXPORT_METHOD(pushLiveRoomOrVideoPlayerWithData:(NSDictionary *)data){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(data[@"video_id"]){
            DYVideoViewController *controller = [[DYVideoViewController alloc] initWithVideoId:data[@"video_id"]];
            [[ControllerTool getCurrentVC] pushViewController:controller animated:YES];
        }else{
            if(data[@"show_style"] && data[@"room_id"] && data[@"room_cover"]){
                NSNumber *showStyle = [NSNumber numberWithInteger:((NSString *)data[@"show_style"]).integerValue];
                NSString *cateType = [NSString stringWithFormat:@"%@",data[@"cate_type"]];
                [DYTabBarManager playerJumpWithType:showStyle
                                            withNVC:[ControllerTool getCurrentVC]
                                         withRoomID:data[@"room_id"]
                                            src_img:[NSURL URLWithString:data[@"room_cover"]]
                                             cateType:cateType];
            }
        }
    });
}




//跳转逻辑
RCT_EXPORT_METHOD(pushContributionDetailWithData:(NSDictionary *)data){
    
    NSNumber *dianbo_count = data[@"dianbo_count"];
    NSString *userid = data[@"userid"];
//    DYAttetionLiveRoomModel *romeModel =  [[DYAttetionLiveRoomModel alloc] initWithDictionary:data[@"zhiboModel"] error:nil]; ;
    
    UINavigationController *currentNavigationController = [ControllerTool getCurrentVC];
    if(dianbo_count.integerValue >= 2){
        DYOthersContributeViewController *controller = [[DYOthersContributeViewController alloc] init];
        
        DYVideoDetailInfoModel *videoInfoModel = [[DYVideoDetailInfoModel alloc] init];
        DYBroadcastVideoModel *videoModel = [[DYBroadcastVideoModel alloc] initWithUserInfoModel:nil videoInfoModel:videoInfoModel categoryModel:nil];
        videoModel.video_info.user_id = userid;
         controller.videoModel = videoModel;
        void (^pushBlock) () = ^{
            [currentNavigationController pushViewController:controller animated:YES];
        };
        
        if([[NSThread currentThread] isMainThread]){
            pushBlock();
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                pushBlock();
            });
        }
    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [DYTabBarManager playerJumpWithType:romeModel.show_style
//                                        withNVC:currentNavigationController
//                                     withRoomID:romeModel.room_id
//                                        src_img:[NSURL URLWithString:romeModel.room_src]];
//        });
        
        
    }
}


@end
