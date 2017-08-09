
package com.reactlibrary;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.util.Log;
import android.util.SparseArray;
import android.view.Gravity;
import android.view.SurfaceView;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.RequestQueue;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import de.hdodenhof.circleimageview.CircleImageView;
import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

public class RNReactNativeAgoraVideochatModule extends ReactContextBaseJavaModule {

    private final static String REACT_NAME = "CommunicationView";
    private final static String PICKER_EVENT_NAME = "viewEvent";
    private static final String TAG = "CommunicationViewModule";

    private final static int REMOTEVIDEO_FLAG = 1;
    private final static int LOCALVIDEORESET_FLAG = 2;
    private final static int COMMECTHIDE_FLAG = 3;

    private RtcEngine mRtcEngine;// Tutorial Step 1


    private String channelID;
    private String appID;
    private String channelKey;
    private String remoteName;
    private String account;
    private String callState;
    private String introText;
    private LinearLayout controlLayoutwait;
    private LinearLayout controlLayout;
    private TextView calltext;
    private TextView introTextView;
    private TextView netStatusTextView;
    private ImageView hangUpImage;
    private ImageView hangInImage;
    private ImageView audioMute;
    private ImageView hangup;
    private ImageView switchCamera;
    private String postUrl;
    private String netStatus;

    private String backgroundImage;
    private String hanginImageUrl;
    private String hangupImageUrl;
    private String muteImage;
    private String unmuteImage;
    private String switchcameraImage;

    private String header;
    private CircleImageView headerImage;
    private FrameLayout localContent;
    private FrameLayout remoteContent;
    private RelativeLayout container;

    private Intent mIntent;
    private NormalLoadPictrue loadPictrueHeader;
    private NormalLoadPictrue loadPictrueHangup;
    private NormalLoadPictrue loadPictrueHangin;
    private NormalLoadPictrue loadPictrueSwitchCamera;
    private NormalLoadPictrue loadPictrueUnmute;
    private NormalLoadPictrue loadPictrueMute;
    private NormalLoadPictrue loadPictruehangupWait;

    private  NormalLoadBackground normalLoadBackground;

    private RequestQueue mQueue;

    private Dialog dialog = null;
    private View view;
    private Context mContent;
    private Boolean ChannelFlag;

    private Handler mHandler = null;
    private SurfaceView remoteSurfaceView = null;
    private SurfaceView localSurfaceView = null;
    private RelativeLayout.LayoutParams localframeParams;
    private RelativeLayout mainLayout;
    private ReadableMap options;
    private SparseArray<SurfaceView> mSurfaceViews;

    public RNReactNativeAgoraVideochatModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContent = reactContext;
    }

    @Override
    public String getName() {
        return REACT_NAME;
    }

    private final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() { // Tutorial Step 1



        @Override
        public void onFirstRemoteVideoDecoded(final int uid, int width, int height, int elapsed) { // Tutorial Step 5
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    setupRemoteVideo(uid);
                }
            });
        }

        @Override
        public void onUserOffline(int uid, int reason) { // Tutorial Step 7
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    onRemoteUserLeft();
                }
            });
        }

        @Override
        public void onUserMuteVideo(final int uid, final boolean muted) { // Tutorial Step 10
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    onRemoteUserVideoMuted(uid, muted);
                }
            });
        }

        @Override
        public void onLeaveChannel(RtcStats stats) {
            super.onLeaveChannel(stats);
            Log.d(TAG, "onLeaveChannel: " + stats);
            mRtcEngine.stopPreview();
            RtcEngine.destroy();
        }

        @Override
        public void onError(int err) {
            super.onError(err);
            Log.d(TAG, "onError: " + err);
        }

        @Override
        public void onCameraReady() {
            super.onCameraReady();
            Log.d(TAG, "onCameraReady: ok");
        }
    };

    class MyHandle extends Handler {

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case REMOTEVIDEO_FLAG:
                    Bundle bundle = msg.getData();
                    int uid = bundle.getInt("uid");
                    remoteSurfaceView = RtcEngine.CreateRendererView(mContent);
                    remoteContent.addView(remoteSurfaceView);
                    mRtcEngine.setupRemoteVideo(new VideoCanvas(remoteSurfaceView, VideoCanvas.RENDER_MODE_HIDDEN, uid));
                    remoteSurfaceView.setTag(uid); // for mark purpose
                    localframeParams = (RelativeLayout.LayoutParams) localContent.getLayoutParams();
                    localframeParams.width = 300;
                    localframeParams.height = 400;
                    localframeParams.setMargins(0,50,50,0);
                    localContent.setLayoutParams(localframeParams);
                    connectShow();
                    break;
//                case LOCALVIDEORESET_FLAG:
//                    Log.d(TAG, "run: 22222");
//                    localframeParams = (RelativeLayout.LayoutParams) localContent.getLayoutParams();
//                    localframeParams.width = MATCH_PARENT;
//                    localframeParams.height = MATCH_PARENT;
//                    localframeParams.setMargins(0,0,0,0);
//                    localContent.setLayoutParams(localframeParams);
//                    break;
//                case COMMECTHIDE_FLAG:
//                    if (callState.equals("inCome")) {
//                        normalLoadBackground.getPicture(backgroundImage,container);
//                        netStatusTextView.setVisibility(View.VISIBLE);
//                    }
//
//                    remoteContent.setVisibility(View.GONE);
//                    localContent.setVisibility(View.GONE);
//                    headerImage.setVisibility(View.VISIBLE);
//                    controlLayoutwait.setVisibility(View.VISIBLE);
//                    controlLayout.setVisibility(View.GONE);
//                    calltext.setVisibility(View.VISIBLE);
//                    introTextView.setVisibility(View.VISIBLE);
//                    remoteContent.removeAllViews();
//                    break;
            }

        }
    }

    private void connectShow(){
        if (callState.equals("inCome")) {
            container.setBackgroundResource(0);
            netStatusTextView.setVisibility(View.GONE);
        }

        remoteContent.setVisibility(View.VISIBLE);
        localContent.setVisibility(View.VISIBLE);
        headerImage.setVisibility(View.GONE);
        controlLayoutwait.setVisibility(View.GONE);
        controlLayout.setVisibility(View.VISIBLE);
        calltext.setVisibility(View.GONE);
        introTextView.setVisibility(View.GONE);
    }

    //初始化视频界面
    @ReactMethod
    public void _init(ReadableMap options){
        this.options = options;
        Activity activity = getCurrentActivity();
        mSurfaceViews = new SparseArray<SurfaceView>();
        if (activity != null){
            mHandler = new MyHandle();
            ChannelFlag = false;
            channelID = options.getString("channelName");
            appID = options.getString("appId");
            header = options.getString("remoteHeader");
            channelKey = options.getString("channelKey");
            remoteName = options.getString("remoteName");
            netStatus = options.getString("netStatus");
            callState = options.getString("callState");
            introText = options.getString("introText");

            backgroundImage = options.getString("backgroundImage");
            hanginImageUrl = options.getString("hanginImage");
            hangupImageUrl = options.getString("hangupImage");
            muteImage = options.getString("muteImage");
            unmuteImage = options.getString("unmuteImage");
            switchcameraImage = options.getString("switchcameraImage");
            Log.d(TAG, "_init:呼入状态 :" + callState);
            if (callState.equals("inCome")){
                Log.d(TAG, "_init: income");
                view = activity.getLayoutInflater().inflate(R.layout.activity_video_chat_view, null);
                mainLayout = (RelativeLayout) view.findViewById(R.id.activity_video_chat_view);
                container = (RelativeLayout) view.findViewById(R.id.container);
                headerImage = (CircleImageView) view.findViewById(R.id.header);
                hangUpImage = (ImageView) view.findViewById(R.id.hangUpImage);
                hangInImage = (ImageView) view.findViewById(R.id.hangInImage);
                audioMute = (ImageView) view.findViewById(R.id.audioMute);
                hangup = (ImageView) view.findViewById(R.id.hangup);
                switchCamera = (ImageView) view.findViewById(R.id.switchCamera);

                normalLoadBackground = new NormalLoadBackground();
                normalLoadBackground.getPicture(backgroundImage,container);

                loadPictrueHeader = new NormalLoadPictrue();
                loadPictrueHeader.getPicture(header,headerImage);

                loadPictrueHangin = new NormalLoadPictrue();
                loadPictrueHangin.getPicture(hanginImageUrl,hangInImage);

                loadPictrueHangup = new NormalLoadPictrue();
                loadPictrueHangup.getPicture(hangupImageUrl,hangUpImage);

                loadPictruehangupWait = new NormalLoadPictrue();
                loadPictruehangupWait.getPicture(hangupImageUrl,hangup);

                loadPictrueUnmute = new NormalLoadPictrue();
                loadPictrueUnmute.getPicture(unmuteImage,audioMute);

                loadPictrueSwitchCamera = new NormalLoadPictrue();
                loadPictrueSwitchCamera.getPicture(switchcameraImage,switchCamera);

                controlLayoutwait = (LinearLayout) view.findViewById(R.id.controlLayoutwait);
                controlLayout = (LinearLayout) view.findViewById(R.id.controlLayout);
                calltext = (TextView) view.findViewById(R.id.calltext);
                introTextView = (TextView) view.findViewById(R.id.introText);
                netStatusTextView = (TextView) view.findViewById(R.id.netStatus);

                if (netStatus.equals("WIFI") || netStatus.equals("wifi")){
                    netStatusTextView.setText("您正在使用WIFI网络,通话免费");
                } else {
                    netStatusTextView.setText("您正在使用数据网络,可能会产生一定费用");
                }
                introTextView.setText(introText);

                hangUpImage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onHangUp();
                    }
                });

                hangInImage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onHangIn();
                    }
                });

                hangup.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onEncCallClicked();
                    }
                });

                switchCamera.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onSwitchCameraClicked(view);
                    }
                });

                audioMute.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onLocalAudioMuteClicked(view);
                    }
                });


                calltext.setText(remoteName);
                controlLayout.setVisibility(View.GONE);

                audioMute = (ImageView) view.findViewById(R.id.audioMute);
                hangup = (ImageView) view.findViewById(R.id.hangup);
                switchCamera = (ImageView) view.findViewById(R.id.switchCamera);

                normalLoadBackground = new NormalLoadBackground();
                normalLoadBackground.getPicture(backgroundImage,container);

                loadPictrueHeader = new NormalLoadPictrue();
                loadPictrueHeader.getPicture(header,headerImage);

                loadPictrueHangin = new NormalLoadPictrue();
                loadPictrueHangin.getPicture(hanginImageUrl,hangInImage);

                loadPictrueHangup = new NormalLoadPictrue();
                loadPictrueHangup.getPicture(hangupImageUrl,hangUpImage);

                loadPictruehangupWait = new NormalLoadPictrue();
                loadPictruehangupWait.getPicture(hangupImageUrl,hangup);

                loadPictrueUnmute = new NormalLoadPictrue();
                loadPictrueUnmute.getPicture(unmuteImage,audioMute);

                loadPictrueSwitchCamera = new NormalLoadPictrue();
                loadPictrueSwitchCamera.getPicture(switchcameraImage,switchCamera);

                controlLayoutwait = (LinearLayout) view.findViewById(R.id.controlLayoutwait);
                controlLayout = (LinearLayout) view.findViewById(R.id.controlLayout);
                calltext = (TextView) view.findViewById(R.id.calltext);
                introTextView = (TextView) view.findViewById(R.id.introText);
                netStatusTextView = (TextView) view.findViewById(R.id.netStatus);

                if (netStatus.equals("WIFI") || netStatus.equals("wifi")){
                    netStatusTextView.setText("您正在使用WIFI网络,通话免费");
                } else {
                    netStatusTextView.setText("您正在使用数据网络,可能会产生一定费用");
                }
                introTextView.setText(introText);

                hangUpImage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onHangUp();
                    }
                });

                hangInImage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onHangIn();
                    }
                });

                hangup.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onEncCallClicked();
                    }
                });

                switchCamera.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onSwitchCameraClicked(view);
                    }
                });

                audioMute.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onLocalAudioMuteClicked(view);
                    }
                });


                calltext.setText(remoteName);
                controlLayout.setVisibility(View.GONE);

            } else if (callState.equals("outPut")) {
                Log.d(TAG, "_init: output");
                view = activity.getLayoutInflater().inflate(R.layout.activity_video_chat_output, null);
                mainLayout = (RelativeLayout) view.findViewById(R.id.activity_video_chat_view);
                headerImage = (CircleImageView) view.findViewById(R.id.header);
                headerImage.setDrawingCacheEnabled(true);

                hangUpImage = (ImageView) view.findViewById(R.id.out_hangup);
                audioMute = (ImageView) view.findViewById(R.id.audioMute);
                hangup = (ImageView) view.findViewById(R.id.hangup);
                switchCamera = (ImageView) view.findViewById(R.id.switchCamera);

                loadPictrueHeader = new NormalLoadPictrue();
                loadPictrueHeader.getPicture(header,headerImage);

                loadPictrueHangup = new NormalLoadPictrue();
                loadPictrueHangup.getPicture(hangupImageUrl,hangUpImage);

                loadPictruehangupWait = new NormalLoadPictrue();
                loadPictruehangupWait.getPicture(hangupImageUrl,hangup);

                loadPictrueUnmute = new NormalLoadPictrue();
                loadPictrueUnmute.getPicture(unmuteImage,audioMute);

                loadPictrueSwitchCamera = new NormalLoadPictrue();
                loadPictrueSwitchCamera.getPicture(switchcameraImage,switchCamera);



                controlLayoutwait = (LinearLayout) view.findViewById(R.id.controlLayoutwait);
                controlLayout = (LinearLayout) view.findViewById(R.id.controlLayout);
                calltext = (TextView) view.findViewById(R.id.calltext);
                introTextView = (TextView) view.findViewById(R.id.introText);

                calltext.setText(remoteName);
                introTextView.setText(introText);

                hangUpImage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onEndCallClickedwait();
                    }
                });

                hangup.setOnClickListener((new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onEncCallClicked();
                    }
                }));

                switchCamera.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onSwitchCameraClicked(view);
                    }
                });

                audioMute.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        onLocalAudioMuteClicked(view);
                    }
                });

                controlLayout.setVisibility(View.GONE);
                initAgoraEngineAndJoinChannel();
                setupVideoProfile();
                setupLocalVideo();
                joinChannel();
            }

            if (dialog == null) {
                dialog = new Dialog(activity, R.style.Dialog_Full_Screen);
                dialog.setContentView(view);
                WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
                Window window = dialog.getWindow();
                if (window != null) {
                    layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
                    layoutParams.format = PixelFormat.TRANSPARENT;
                    layoutParams.windowAnimations = R.style.PickerAnim;
                    layoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
                    layoutParams.height = WindowManager.LayoutParams.MATCH_PARENT;
                    layoutParams.gravity = Gravity.BOTTOM;
                    window.setAttributes(layoutParams);
                }
            } else {
                dialog.dismiss();
            }
        }
    }

    private void initAgoraEngineAndJoinChannel() {
        initializeAgoraEngine();     // Tutorial Step 1
    }

    // Tutorial Step 10
    public void onLocalVideoMuteClicked(View view) {
        ImageView iv = (ImageView) view;
        if (iv.isSelected()) {
            iv.setSelected(false);
            iv.clearColorFilter();
        } else {
            iv.setSelected(true);
            iv.setColorFilter(mContent.getResources().getColor(R.color.catalyst_redbox_background), PorterDuff.Mode.MULTIPLY);
        }

        mRtcEngine.muteLocalVideoStream(iv.isSelected());

        FrameLayout container = (FrameLayout) view.findViewById(R.id.local_video_view_container);
        SurfaceView surfaceView = (SurfaceView) container.getChildAt(0);
        surfaceView.setZOrderMediaOverlay(!iv.isSelected());
        surfaceView.setVisibility(iv.isSelected() ? View.GONE : View.VISIBLE);
    }

    // Tutorial Step 9
    public void onLocalAudioMuteClicked(View view) {
        ImageView iv = (ImageView) view;

        if (iv.isSelected()) {
            iv.setSelected(false);
//            iv.clearColorFilter();
            iv.setImageDrawable(mContent.getResources().getDrawable(R.mipmap.unmute));
        } else {
            iv.setSelected(true);
            iv.setImageDrawable(mContent.getResources().getDrawable(R.mipmap.mute));
//            iv.setColorFilter(getResources().getColor(R.color.catalyst_redbox_background), PorterDuff.Mode.MULTIPLY);
        }

        mRtcEngine.muteLocalAudioStream(iv.isSelected());
    }

    // Tutorial Step 8
    public void onSwitchCameraClicked(View view) {
        mRtcEngine.switchCamera();
    }

    // Tutorial Step 1
    private void initializeAgoraEngine() {
        Log.d(TAG, "initializeAgoraEngine: 111111");
        mRtcEngine = RtcEngine.create(mContent, appID, mRtcEventHandler);

        Log.d(TAG, "initializeAgoraEngine: 111111" + mRtcEngine);
    }

    // Tutorial Step 2
    private void setupVideoProfile() {
        Log.d(TAG, "setupVideoProfile: 222222");
        mRtcEngine.enableVideo();
        mRtcEngine.setVideoProfile(Constants.VIDEO_PROFILE_720P, false);
    }

    // Tutorial Step 3
    private void setupLocalVideo() {
        Log.d(TAG, "setupLocalVideo: 33333");
        SurfaceView localSurfaceView = RtcEngine.CreateRendererView(getReactApplicationContext());
        localSurfaceView.setZOrderMediaOverlay(true);
        localContent = (FrameLayout) view.findViewById(R.id.local_video_view_container);
        localContent.addView(localSurfaceView);
        mRtcEngine.setupLocalVideo(new VideoCanvas(localSurfaceView, VideoCanvas.RENDER_MODE_HIDDEN, 0));
        if (callState.equals("outPut")){
            mRtcEngine.startPreview();
        }
    }

    // Tutorial Step 4
    private void joinChannel() {
        Log.d(TAG, "joinChannel: channelID:" + channelID );
        mRtcEngine.joinChannel(channelKey, channelID, "", 0); // if you do not specify the uid, we will generate the uid for you
        ChannelFlag = true;
    }

    // Tutorial Step 5
    private void setupRemoteVideo(final int uid) {
        final int myUid = uid;
        remoteContent = (FrameLayout) view.findViewById(R.id.remote_video_view_container);
        remoteContent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (controlLayout.getVisibility() == View.VISIBLE){
                    controlLayout.setVisibility(View.GONE);
                } else {
                    controlLayout.setVisibility(View.VISIBLE);
                }
            }
        });
        if (remoteContent.getChildCount() >= 1) {
            return;
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                Message msg = new Message();
                msg.what = REMOTEVIDEO_FLAG;
                Bundle bundle = new Bundle();
                bundle.putInt("uid",myUid);
                msg.setData(bundle);
                mHandler.sendMessage(msg);
            }
        }).start();
    }

    // Tutorial Step 6
    private void leaveChannel() {
        mRtcEngine.leaveChannel();
        hide();
    }

    // Tutorial Step 7
    private void onRemoteUserLeft() {
//        FrameLayout container = (FrameLayout) view.findViewById(R.id.remote_video_view_container);
//        container.removeAllViews();
        mRtcEngine.leaveChannel();
        commonEvent("hangupByPeer");
        hide();
    }

    // Tutorial Step 10
    private void onRemoteUserVideoMuted(int uid, boolean muted) {
        FrameLayout container = (FrameLayout) view.findViewById(R.id.remote_video_view_container);

        SurfaceView surfaceView = (SurfaceView) container.getChildAt(0);

        Object tag = surfaceView.getTag();
        if (tag != null && (Integer) tag == uid) {
            surfaceView.setVisibility(muted ? View.GONE : View.VISIBLE);
        }
    }


    //拒绝视频
    private void onHangUp(){
        commonEvent("hangupIncome");
        hide();
    }

    //接听视频
    private void onHangIn(){
        Log.d(TAG, "onHangIn");
        commonEvent("hangin");
        initAgoraEngineAndJoinChannel();
        setupVideoProfile();         // Tutorial Step 2
        setupLocalVideo();           // Tutorial Step 3
        joinChannel();
    }

    private void onEndCallClickedwait(){
        commonEvent("hangupCalling");
//        localContent.removeAllViews();
        hide();
    }

    public void onEncCallClicked() {
        commonEvent("hangup");
        mRtcEngine.leaveChannel();
        hide();
    }

    @ReactMethod
    public void show() {
        if (dialog == null) {
            return;
        }
        if (!dialog.isShowing()) {
            dialog.show();
        }
    }

    @ReactMethod
    public void hide() {
        if (dialog == null) {
            return;
        }
        if (dialog.isShowing()) {
            if (ChannelFlag) {
                callState = null;
                view = null;
                mRtcEngine.leaveChannel();
                mRtcEngine.stopPreview();
            }
            dialog.dismiss();
            dialog = null;
        }
    }

    private void commonEvent(String eventKey) {
        WritableMap map = Arguments.createMap();
        map.putString("type", eventKey);
        map.putInt("status", 200);
        sendEvent(getReactApplicationContext(), PICKER_EVENT_NAME, map);
    }

    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private class NormalLoadPictrue {

        private String uri;
        private ImageView imageView;
        private byte[] picByte;


        public void getPicture(String uri, ImageView imageView) {
            this.uri = uri;
            this.imageView = imageView;
            new Thread(runnable).start();
        }

        @SuppressLint("HandlerLeak")
        Handler handle = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                if (msg.what == 1) {
                    if (picByte != null) {
                        Bitmap bitmap = BitmapFactory.decodeByteArray(picByte, 0, picByte.length);
                        imageView.setImageBitmap(bitmap);
                    }
                }
            }
        };

        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                try {
                    URL url = new URL(uri);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setReadTimeout(10000);

                    if (conn.getResponseCode() == 200) {
                        InputStream fis = conn.getInputStream();
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        byte[] bytes = new byte[1024];
                        int length = -1;
                        while ((length = fis.read(bytes)) != -1) {
                            bos.write(bytes, 0, length);
                        }
                        picByte = bos.toByteArray();
                        bos.close();
                        fis.close();

                        Message message = new Message();
                        message.what = 1;
                        handle.sendMessage(message);
                    }


                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };
    }

    private class NormalLoadBackground {

        private String uri;
        private RelativeLayout relativeLayout;
        private byte[] picByte;


        public void getPicture(String uri, RelativeLayout relativeLayout) {
            this.uri = uri;
            this.relativeLayout = relativeLayout;
            new Thread(runnable).start();
        }

        @SuppressLint("HandlerLeak")
        Handler handle = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                if (msg.what == 1) {
                    if (picByte != null) {
                        Bitmap bitmap = BitmapFactory.decodeByteArray(picByte, 0, picByte.length);
                        Drawable drawable = new BitmapDrawable(bitmap);
                        relativeLayout.setBackground(drawable);
                    }
                }
            }
        };

        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                try {
                    URL url = new URL(uri);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setReadTimeout(10000);

                    if (conn.getResponseCode() == 200) {
                        InputStream fis = conn.getInputStream();
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        byte[] bytes = new byte[1024];
                        int length = -1;
                        while ((length = fis.read(bytes)) != -1) {
                            bos.write(bytes, 0, length);
                        }
                        picByte = bos.toByteArray();
                        bos.close();
                        fis.close();

                        Message message = new Message();
                        message.what = 1;
                        handle.sendMessage(message);
                    }


                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };
    }
}