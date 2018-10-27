
#import "MyModule.h"
#import "DYHistoryManager.h"
@implementation MyModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
//  RCTLogInfo(@"add an event %@ at %@", name, location);
  NSLog(@"%@-%@",name,location);
}
//获取历史直播列表
RCT_EXPORT_METHOD(historyLiveCallbackEvent:(NSString *)event callback:(RCTResponseSenderBlock)callback)
{
    [[DYHistoryManager shareInstance]getLiveRoomDatacallback:^(NSString *jsonOneStr, NSString *jsonTwoStr) {
        callback(@[[NSNull null],jsonOneStr,jsonTwoStr]);
    }];
}

//获取历史点播列表
RCT_EXPORT_METHOD(historyVideoCallbackEvent:(NSString *)event  callback:(RCTResponseSenderBlock)callback)
{
    [[DYHistoryManager shareInstance] getVideoRoomDatacallback:^(NSString *jsonStr) {
        callback(@[[NSNull null],jsonStr]);
    }];
}
//跳转点播间
RCT_EXPORT_METHOD(RNOpenPlayerVC:(NSString *)detailMsg){
    NSLog(@"__________%@", detailMsg);
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        DYVideoViewController *vc = [[DYVideoViewController alloc] initWithVideoId:detailMsg];
        [[ControllerTool getCurrentVC] pushViewController:vc animated:YES ];
    });
}
//跳转直播间
RCT_EXPORT_METHOD(RNOpenLiveVC:(NSString *)type data:(NSDictionary*)data){
    NSLog(@"__________%@", type);
    if (type.intValue ==1 ) {
//        主要这里必须使用主线程发送,不然有可能失效
            dispatch_async(dispatch_get_main_queue(), ^{
               
            });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
       
        });
    }

}
//跳转网路修复页面
RCT_EXPORT_METHOD(seeFix){
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
       
    });
}
//跳转联系我们
RCT_EXPORT_METHOD(seeMore){
    //主要这里必须使用主线程发送,不然有可能失效
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
}
//Promises
//  对外提供调用方法,演示Promise使用
RCT_REMAP_METHOD(testPromisesEvent,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *PromisesData = @"Promises数据"; //准备回调回去的数据
  if (PromisesData) {
    resolve(PromisesData);
  } else {
    NSError *error=[NSError errorWithDomain:@"我是Promise回调错误信息..." code:101 userInfo:nil];
    reject(@"no_events", @"There were no events", error);
  }
}

- (NSDictionary *)constantsToExport
{
  return @{ @"ValueOne": @"我是从原生定义的~" };
}
+(BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    key = @"Zcr4mev5WEsQJ74RE_2xKELteoRcUS62";
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"426332153",@"cdf8133bcc79823c047bf59b3264d076cb9f5a4b5868f78f78a5dd71da8a0889"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    if([[UIApplication sharedApplication] canOpenURL:url]){
//        [[UIApplication sharedApplication] openURL:url];
//        return YES;
//    }
     return NO;
}

@end
