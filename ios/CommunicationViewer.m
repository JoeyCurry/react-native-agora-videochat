//
//  CommunicationViewer.m
//  patient_app
//
//  Created by jiangjun on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CommunicationViewer.h"

@implementation CommunicationViewer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.videoDic=dic;
    self.remoteFlag = false;
    self.netStatus = [dic objectForKey:@"netStatus"];
    self.remoteName = [dic objectForKey:@"remoteName"];
    self.remoteHeader = [dic objectForKey:@"remoteHeader"];
    self.introText = [dic objectForKey:@"introText"];
    self.channelKey = [dic objectForKey:@"channelKey"];
    self.channelName = [dic objectForKey:@"channelName"];
    self.appId = [dic objectForKey:@"appId"];
    self.callState = [dic objectForKey:@"callState"];
    self.backgroundImage = [dic objectForKey:@"backgroundImage"];
    self.hangupImage = [dic objectForKey:@"hangupImage"];
    self.hanginImage = [dic objectForKey:@"hanginImage"];
    self.muteImage = [dic objectForKey:@"muteImage"];
    self.unmuteImage = [dic objectForKey:@"unmuteImage"];
    self.switchcameraImage = [dic objectForKey:@"switchcameraImage"];
    NSLog(@"%@", self.callState);
    dispatch_async(dispatch_get_main_queue(), ^{
      [self makeuiWith];
    });
  }
  return self;
}

-(void)makeuiWith{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  if ([self.netStatus isEqualToString:@"wifi"]) {
    self.netStatusText = @"您正在使用WIFI网络,通话免费";
  } else {
    self.netStatusText = @"您正在使用数据网络,可能会产生一定费用";
  }
  
  if ([self.callState isEqualToString:@"inCome"]) {
    UIImage * backgroundImage = [self getImageFromURL:self.backgroundImage];
    self.background = [[UIImageView alloc]initWithImage:backgroundImage];
    self.background.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.localVideo = [[UIView alloc] init];
    self.localVideo.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.remoteVideo = [[UIView alloc] init];
    self.remoteVideo.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //接听的文字
    self.callTexthangin=[[UILabel alloc] init];
    self.callTexthangin.text = @"接听";
    self.callTexthangin.numberOfLines = 0;
    self.callTexthangin.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:178.5/255.0];
    self.callTexthangin.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.callTexthangin.lineBreakMode = NSLineBreakByTruncatingTail;//设置换行模式
    CGSize maximumLabelSize = CGSizeMake(9999, 9999);//labelsize的最大值
    CGSize hangin = [self.callTexthangin sizeThatFits:maximumLabelSize];
    self.callTexthangin.frame = CGRectMake(SCREEN_WIDTH/2 + 58.5 + 33.5 - hangin.width/2, SCREEN_HEIGHT - 35 - hangin.height , hangin.width, hangin.height);
    
    //拒绝的文字
    self.callTexthangup=[[UILabel alloc] init];
    self.callTexthangup.text = @"拒绝";
    self.callTexthangup.numberOfLines = 0;
    self.callTexthangup.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:178.5/255.0];
    self.callTexthangup.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.callTexthangup.lineBreakMode = NSLineBreakByTruncatingTail;//设置换行模式
    CGSize hangup = [self.callTexthangup sizeThatFits:maximumLabelSize];
    self.callTexthangup.frame = CGRectMake(SCREEN_WIDTH/2 - 125.5 + 33.5 - hangup.width/2, SCREEN_HEIGHT - 35 - hangup.height , hangup.width, hangup.height);
    
    //医生的名字
    self.callName=[[UILabel alloc] init];
    self.callName.text = self.remoteName;
    self.callName.numberOfLines = 0;
    self.callName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:229.5/255.0];
    self.callName.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    self.callName.lineBreakMode = NSLineBreakByTruncatingTail;//设置换行模式
    CGSize name = [self.callName sizeThatFits:maximumLabelSize];
    self.callName.frame = CGRectMake(SCREEN_WIDTH/2 - name.width/2, 182 , name.width, name.height);
    
    //邀请您视频问诊
    self.callText=[[UILabel alloc] init];
    self.callText.text = self.introText;
    self.callText.numberOfLines = 0;
    self.callText.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:178.5/255.0];
    self.callText.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    self.callText.lineBreakMode = NSLineBreakByTruncatingTail;//设置换行模式
    CGSize text = [self.callText sizeThatFits:maximumLabelSize];
    self.callText.frame = CGRectMake(SCREEN_WIDTH/2 - text.width/2,  210, text.width, text.height);
    
    //您正在使用WIFI网络，通话免费
    self.callText1=[[UILabel alloc] init];
    self.callText1.text = self.netStatusText;
    self.callText1.numberOfLines = 0;
    self.callText1.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:178.5/255.0];
    self.callText1.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.callText1.lineBreakMode = NSLineBreakByTruncatingTail;//设置换行模式
    CGSize text1 = [self.callText1 sizeThatFits:maximumLabelSize];
    self.callText1.frame = CGRectMake(SCREEN_WIDTH/2 - text1.width/2, 243 , text1.width, text1.height);
    
    //头像
    UIImage * headerImage = [self getImageFromURL:self.remoteHeader];
    self.headerImageView = [[UIImageView alloc]initWithImage:headerImage];
    self.headerImageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 42.5, 79, 85, 85);
    self.headerImageView.layer.masksToBounds =YES;
    self.headerImageView.layer.cornerRadius = 42.5;
    
    //hangupbutton挂断来电
    self.hangupbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.hangupbutton.frame = CGRectMake(SCREEN_WIDTH/2 - 125.5, SCREEN_HEIGHT - 138, 67, 67);
    UIImage * hangupImage = [self getImageFromURL:self.hangupImage];
    [self.hangupbutton setBackgroundImage:hangupImage forState:UIControlStateNormal];
    [self.hangupbutton addTarget:self action:@selector(hangupIncome) forControlEvents:(UIControlEventTouchUpInside)];
    
    //hanginbutton接听来电
    self.hanginbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.hanginbutton.frame = CGRectMake(SCREEN_WIDTH/2 + 58.5, SCREEN_HEIGHT - 138, 67, 67);
    UIImage * hanginImage = [self getImageFromURL:self.hanginImage];
    [self.hanginbutton setBackgroundImage:hanginImage forState:UIControlStateNormal];
    [self.hanginbutton addTarget:self action:@selector(hangin) forControlEvents:(UIControlEventTouchUpInside)];
    //hangupbutton2视频内挂断视频
    self.hangupbutton2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.hangupbutton2.frame = CGRectMake(SCREEN_WIDTH/2 - 30, SCREEN_HEIGHT - 130, 60, 60);
    [self.hangupbutton2 setBackgroundImage:hangupImage forState:UIControlStateNormal];
    [self.hangupbutton2 addTarget:self action:@selector(hangupbutton2:) forControlEvents:(UIControlEventTouchUpInside)];
    //switchCamera切换摄像头
    self.switchCamera = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.switchCamera.frame = CGRectMake(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 130, 60, 60);
    UIImage * switchcameraImage = [self getImageFromURL:self.switchcameraImage];
    [self.switchCamera setBackgroundImage:switchcameraImage forState:UIControlStateNormal];
    [self.switchCamera addTarget:self action:@selector(switchCamera:) forControlEvents:(UIControlEventTouchUpInside)];
    //switchbutton切换是否关闭麦克风
    self.switchbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.switchbutton.frame = CGRectMake(SCREEN_WIDTH/2 + 90, SCREEN_HEIGHT - 130, 60, 60);
    UIImage * unmuteImage = [self getImageFromURL:self.unmuteImage];
    [self.switchbutton setBackgroundImage:unmuteImage forState:UIControlStateNormal];
    [self.switchbutton addTarget:self action:@selector(switchbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:self.background];
    [view addSubview:self.remoteVideo];
    [view addSubview:self.localVideo];
    [view addSubview:self.switchbutton];
    [view addSubview:self.hangupbutton];
    [view addSubview:self.hanginbutton];
    [view addSubview:self.hangupbutton2];
    [view addSubview:self.headerImageView];
    [view addSubview:self.callName];
    [view addSubview:self.callText];
    [view addSubview:self.callText1];
    [view addSubview:self.callTexthangin];
    [view addSubview:self.callTexthangup];
    [view addSubview:self.switchCamera];
    
    [self addSubview:view];
    
    self.switchbutton.hidden = true;
    self.switchCamera.hidden = true;
    self.hangupbutton2.hidden = true;
    //  self.localVideo.hidden = true;
    //  self.remoteVideo.hidden = true;
    
    //  UITapGestureRecognizer *localClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLocalClick:)];
    UITapGestureRecognizer *remoteClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleRemoteClick:)];
    //  [self.localVideo addGestureRecognizer:localClick]; // 添加手势监听
    [self.remoteVideo addGestureRecognizer:remoteClick]; // 添加手势监听
  } else if ([self.callState isEqualToString:@"outPut"]){
    self.localVideo = [[UIView alloc] init];
    self.localVideo.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.remoteVideo = [[UIView alloc] init];
    self.remoteVideo.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.callText2=[[UILabel alloc] initWithFrame:CGRectMake(150, 50, 300, 100)];
    self.callText2.text = self.introText;
    self.callText2.textColor = [UIColor whiteColor];
    self.callText2.font = [UIFont systemFontOfSize:18];
    self.callText2.lineBreakMode = NSLineBreakByTruncatingHead;//设置换行模式
    
    self.callText=[[UILabel alloc] initWithFrame:CGRectMake(150, 15, 300, 100)];
    self.callText.text = self.remoteName;
    self.callText.textColor = [UIColor whiteColor];
    self.callText.font = [UIFont systemFontOfSize:18];
    self.callText.lineBreakMode = NSLineBreakByTruncatingHead;//设置换行模式
    NSString* headerURL = self.remoteHeader;

    UIImage * headerImage = [self getImageFromURL:headerURL];
    self.headerImageView = [[UIImageView alloc]initWithImage:headerImage];
    self.headerImageView.frame = CGRectMake(40, 40, 80, 80);
    self.headerImageView.layer.masksToBounds =YES;
    self.headerImageView.layer.cornerRadius = 40;
    
    //hangupbutton终止呼叫
    self.hangupbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.hangupbutton.frame = CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT - 130, 80, 80);
    UIImage * hangupImage = [self getImageFromURL:self.hangupImage];
    [self.hangupbutton setBackgroundImage:hangupImage forState:UIControlStateNormal];
    [self.hangupbutton addTarget:self action:@selector(hangupCalling) forControlEvents:(UIControlEventTouchUpInside)];
    //hangupbutton2视频内挂断视频
    self.hangupbutton2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.hangupbutton2.frame = CGRectMake(SCREEN_WIDTH/2 - 30, SCREEN_HEIGHT - 130, 60, 60);
    [self.hangupbutton2 setBackgroundImage:hangupImage forState:UIControlStateNormal];
    [self.hangupbutton2 addTarget:self action:@selector(hangupbutton2:) forControlEvents:(UIControlEventTouchUpInside)];
    //switchCamera切换摄像头
    self.switchCamera = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.switchCamera.frame = CGRectMake(SCREEN_WIDTH/2 + 90, SCREEN_HEIGHT - 130, 60, 60);
    UIImage * switchcameraImage = [self getImageFromURL:self.switchcameraImage];
    [self.switchCamera setBackgroundImage:switchcameraImage forState:UIControlStateNormal];
    [self.switchCamera addTarget:self action:@selector(switchCamera:) forControlEvents:(UIControlEventTouchUpInside)];
    //switchbutton切换是否关闭麦克风
    self.switchbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.switchbutton.frame = CGRectMake(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT - 130, 60, 60);
    UIImage * unmuteImage = [self getImageFromURL:self.unmuteImage];
    [self.switchbutton setBackgroundImage:unmuteImage forState:UIControlStateNormal];
    [self.switchbutton addTarget:self action:@selector(switchbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [view addSubview:self.remoteVideo];
    [view addSubview:self.localVideo];
    [view addSubview:self.switchbutton];
    [view addSubview:self.hangupbutton];
    [view addSubview:self.hangupbutton2];
    [view addSubview:self.headerImageView];
    [view addSubview:self.callText];
    [view addSubview:self.callText2];
    [view addSubview:self.switchCamera];
    
    [self addSubview:view];
    
    self.switchbutton.hidden = true;
    self.switchCamera.hidden = true;
    self.hangupbutton2.hidden = true;
    
    //  UITapGestureRecognizer *localClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLocalClick:)];
    UITapGestureRecognizer *remoteClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleRemoteClick:)];
    //  [self.localVideo addGestureRecognizer:localClick]; // 添加手势监听
    [self.remoteVideo addGestureRecognizer:remoteClick]; // 添加手势监听
    
    [self setupButtons];            // Tutorial Step 8
    [self hideVideoMuted];          // Tutorial Step 10
    [self initializeAgoraEngine];   // Tutorial Step 1
    [self setupVideo];              // Tutorial Step 2
    [self setupLocalVideo];         // Tutorial Step 3
    [self joinChannel];             // Tutorial Step 4

  }
}

// Tutorial Step 1
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.appId delegate:self];
}

// Tutorial Step 2
- (void)setupVideo {
    [self.agoraKit enableVideo];
    // Default mode is disableVideo
  
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_720P swapWidthAndHeight: false];
    // Default video profile is 360P
}

//// Tutorial Step 3
- (void)setupLocalVideo {
  AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
  videoCanvas.uid = 0;
  // UID = 0 means we let Agora pick a UID for us
  
  videoCanvas.view = self.localVideo;
  videoCanvas.renderMode = AgoraRtc_Render_Hidden;
  [self.agoraKit setupLocalVideo:videoCanvas];
  if ([self.callState isEqualToString:@"outPut"]) {
    [self.agoraKit startPreview];
  }
  //    [self.agoraKit startPreview];
  // Bind local video stream to view
}
//
// Tutorial Step 4
- (void)joinChannel {
  [self.agoraKit joinChannelByKey:self.channelKey channelName:self.channelName info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
    // Join channel "demoChannel1"
    [self.agoraKit setEnableSpeakerphone:YES];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.channelFlag = true;
  }];
  // The UID database is maintained by your app to track which users joined which channels. If not assigned (or set to 0), the SDK will allocate one and returns it in joinSuccessBlock callback. The App needs to record and maintain the returned value as the SDK does not maintain it.
}
//
// Tutorial Step 5
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
  if (self.remoteVideo.hidden)
    self.remoteVideo.hidden = false;
  AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
  videoCanvas.uid = uid;
  // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
  
  videoCanvas.view = self.remoteVideo;
  videoCanvas.renderMode = AgoraRtc_Render_Hidden;
  [self.agoraKit setupRemoteVideo:videoCanvas];
  // Bind remote video stream   to view
  [self didRemoteJoin];
  if (self.remoteVideo.hidden)
    self.remoteVideo.hidden = false;
}
//
// Tutorial Step 6
- (IBAction)hangUpButton:(UIButton *)sender {
  [self leaveChannel];
}

- (void)leaveChannel {
  [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.remoteVideo removeFromSuperview];
    [self.localVideo removeFromSuperview];
    self.agoraKit = nil;
  }];
  
}

// Tutorial Step 7
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
  self.remoteVideo.hidden = true;
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"hangupByPeer"
//                                                      object:self];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  [dic setObject:@200 forKey:@"status"];
  [dic setValue:@"hangupByPeer" forKey:@"type"];
  self.bolock(dic);
  [self leaveChannel];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.2f animations:^{
      
      [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
  });
}

// Tutorial Step 8
- (void)setupButtons {
  
}

- (void)hideControlButtons {
  
}

- (void)remoteVideoTapped:(UITapGestureRecognizer *)recognizer {
  
}



- (void)resetHideButtonsTimer {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
}

// Tutorial Step 9
- (IBAction)didClickMuteButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.agoraKit muteLocalAudioStream:sender.selected];
  [self resetHideButtonsTimer];
}

// Tutorial Step 10
- (IBAction)didClickVideoMuteButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.agoraKit muteLocalVideoStream:sender.selected];
  self.localVideo.hidden = sender.selected;
  [self resetHideButtonsTimer];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
  self.remoteVideo.hidden = muted;
  
}

- (void) hideVideoMuted {
  
}

// Tutorial Step 11
- (IBAction)didClickSwitchCameraButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.agoraKit switchCamera];
  [self resetHideButtonsTimer];
}

- (void)didRemoteJoin{
  
  AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
  videoCanvas.uid = 0;
  // UID = 0 means we let Agora pick a UID for us
  
  videoCanvas.view = self.localVideo;
  
  videoCanvas.renderMode = AgoraRtc_Render_Adaptive;
  self.localVideo.frame = CGRectMake(SCREEN_WIDTH - 160, 40, 140, 200);
  self.background.hidden = true;
  self.hangupbutton.hidden = true;
  self.hanginbutton.hidden = true;
  self.switchbutton.hidden = false;
  self.switchCamera.hidden = false;
  self.hangupbutton2.hidden = false;
  self.headerImageView.hidden = true;
  self.callName.hidden = true;
  self.callText.hidden = true;
  self.callText1.hidden = true;
  self.callText2.hidden = true;
  self.callTexthangin.hidden = true;
  self.callTexthangup.hidden = true;
  self.localVideo.hidden = false;
  self.remoteVideo.hidden = false;
  
  [self.agoraKit setupLocalVideo:videoCanvas];
  
  
}


//按了拒绝来电
-(void)hangupIncome{
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  [dic setObject:@200 forKey:@"status"];
  [dic setValue:@"hangupIncome" forKey:@"type"];
  self.bolock(dic);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.2f animations:^{
      
      [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
  });
}

//停止呼叫
-(void)hangupCalling{
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  [dic setObject:@200 forKey:@"status"];
  [dic setValue:@"hangupCalling" forKey:@"type"];
  self.bolock(dic);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.2f animations:^{
      
      [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
  });
}

//接听来电
-(void)hangin{
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  [dic setObject:@200 forKey:@"status"];
  [dic setValue:@"hangin" forKey:@"type"];
  self.bolock(dic);
  
//  [self.inst channelJoin:self.channelName ];
  [self initializeAgoraEngine];   // Tutorial Step 1
  [self setupVideo];              // Tutorial Step 2
  [self setupLocalVideo];         // Tutorial Step 3
  [self joinChannel];
  
}

//挂断电话
- (void)hangupbutton2:(UIButton *)sender{
  [self leaveChannel];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  [dic setObject:@200 forKey:@"status"];
  [dic setValue:@"hangup" forKey:@"type"];
  self.bolock(dic);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.2f animations:^{
      
      [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
  });
}

//切换是否关闭麦克风
- (void)switchbutton:(UIButton *)sender{
  sender.selected = !sender.selected;
  UIImage * unmuteImage = [self getImageFromURL:self.unmuteImage];
  UIImage * muteImage = [self getImageFromURL:self.muteImage];
  if (sender.selected) {
    [self.switchbutton setBackgroundImage:muteImage forState:UIControlStateNormal];
  } else {
    [self.switchbutton setBackgroundImage:unmuteImage forState:UIControlStateNormal];
  }
  //  sender.selected = !sender.selected;
  [self.agoraKit muteLocalAudioStream:sender.selected];
  [self resetHideButtonsTimer];
}

//切换摄像头
- (void)switchCamera:(UIButton *)sender{
  [self.agoraKit switchCamera];
  [self resetHideButtonsTimer];
}

-(void) handleRemoteClick:(UITapGestureRecognizer *)recoqnizer {
  if(self.remoteFlag){
    self.switchbutton.hidden = false;
    self.switchCamera.hidden = false;
    self.hangupbutton2.hidden = false;
  } else {
    self.switchbutton.hidden = true;
    self.switchCamera.hidden = true;
    self.hangupbutton2.hidden = true;
  }
  self.remoteFlag = !self.remoteFlag;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
  
  UIImage * result;
  NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
  result = [UIImage imageWithData:data];
  return result;
}

@end
