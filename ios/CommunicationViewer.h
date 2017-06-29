//
//  CommunicationViewer.h
//  patient_app
//
//  Created by jiangjun on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

typedef void(^backBolock)(NSDictionary * );

@interface CommunicationViewer : UIView

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@property NSUserDefaults *userDefaultes;
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;          // Tutorial Step 1
//@property (weak, nonatomic) IBOutlet UIView *localVideo;            // Tutorial Step 3
//@property (weak, nonatomic) IBOutlet UIView *remoteVideo;           // Tutorial Step 5
@property UIView *localVideo;
@property UIView *remoteVideo;
@property UIButton *switchbutton;
@property UIButton *hangupbutton;
@property UIButton *hangupbutton2;
@property UIButton *hanginbutton;

@property UIButton *switchCamera;
@property UILabel *callName;
@property UILabel *callText;
@property UILabel *callText1;
@property UILabel *callText2;
@property UILabel *callTexthangin;
@property UILabel *callTexthangup;
@property UIImageView *headerImageView;
@property UIImageView *background;

@property Boolean* remoteFlag; //对方的状态
@property NSString* netStatus;//网络状态
@property NSString* netStatusText; //网络状态文字
@property NSString* remoteName; //通讯对方的名称
@property NSString* remoteHeader; //通讯对方的头像
@property NSString* introText; //视频介绍文字
@property NSString* channelKey; //声网频道key
@property NSString* channelName; //通讯的房间名
@property NSString* appId; //声网appId
@property NSString* callState; //呼叫状态：呼出或被呼叫 inCome outPut
@property NSString* backgroundImage; //呼入界面的背景图
@property NSString* hangupImage; //挂断
@property NSString* hanginImage; //接听
@property NSString* muteImage; //有声音
@property NSString* unmuteImage; //静音
@property NSString* switchcameraImage;//切换摄像头

@property Boolean* channelFlag; //是否加入channel



@property (strong, nonatomic) NSDictionary *videoDic;//一开始进来的字典
@property(nonatomic,strong)NSMutableArray *backArry;
@property(nonatomic,copy)backBolock bolock;

-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic;

@end
