//
//  OCNativeEvent.m


#import "OCNativeEvent.h"


@implementation OCNativeEvent
RCT_EXPORT_MODULE();

static OCNativeEvent *historyNativeEvent;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        historyNativeEvent  = [[OCNativeEvent alloc]init];
    });
    
    return historyNativeEvent;
}
// 在添加第一个监听函数时触发
-(void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshistoryList:) name:@"refreshCurrentPage" object:nil];

}

-(void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)refreshistoryList:(NSNotification*)noti{
    
      [self sendEventWithName:@"refreshCurrentPage"
                               body:@{
                                      @"code": @"hhh",
                                      @"result": @"dfhf",
                                      }];
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"refreshCurrentPage"];//导出你的方法，数组结构。
}

+(void)popViewControllerCallback
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCurrentPage" object:nil];
    
}

@end
