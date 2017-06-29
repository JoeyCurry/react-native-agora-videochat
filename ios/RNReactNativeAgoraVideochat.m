
#import "RNReactNativeAgoraVideochat.h"
#import <React/RCTLog.h>
#import "CommunicationViewer.h"
#import <React/RCTEventDispatcher.h>

@interface RNReactNativeAgoraVideochat()

@property(nonatomic,strong)CommunicationViewer *viewer;
@property(nonatomic,weak)UIWindow * window;
@property Boolean *channelFlag;

@end


@implementation RNReactNativeAgoraVideochat

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(CommunicationView);

RCT_EXPORT_METHOD(_init:(NSDictionary *)indic){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    });
    
    self.window = [UIApplication sharedApplication].keyWindow;
    [self.window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[CommunicationViewer class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [obj removeFromSuperview];
            });
        }
        
    }];
    
    self.viewer = [[CommunicationViewer alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) dic:indic ];
    
    _viewer.bolock=^(NSDictionary *backinfoArry){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.bridge.eventDispatcher sendAppEventWithName:@"viewEvent" body:backinfoArry];
        });
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.window addSubview:_viewer];
        
        [UIView animateWithDuration:.3 animations:^{
            
            [_viewer setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
        }];
        
    });
    
}

RCT_EXPORT_METHOD(show){
    
    if (self.viewer) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                
                [_viewer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
            }];
        });
    }return;
}

RCT_EXPORT_METHOD(hide){
    
    if (self.viewer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                [_viewer setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }];
        });
    }return;
}


RCT_EXPORT_METHOD(isViewerShow:(RCTResponseSenderBlock)getBack){
    
    if (self.viewer) {
        
        CGFloat pickY= _viewer.frame.origin.y;
        
        if (pickY==SCREEN_HEIGHT) {
            
            getBack(@[@YES]);
        } else {
            getBack(@[@NO]);
        }
    }else{
        getBack(@[@"viewer不存在"]);
    }
}


@end
  
