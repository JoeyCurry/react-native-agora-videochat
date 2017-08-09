/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableOpacity
} from 'react-native';
import Viewer from 'react-native-agora-videochat'
// import Viewer from './viewer.js'

const TEST_IMAGE_URL = 'http://images.nuanxin-health.com/'//图片地址
const BASE_AGORA_URL = 'http://www.jinma-health.com/agora/'; // 申网接口的base_url
const SIGNALINGKEY_URL = BASE_AGORA_URL + 'signaling_key'; // 登录声网信令所需的signaling_key
const CHANNELKEY_URL = BASE_AGORA_URL + 'channel_key'; // 登录声网信令所需的signaling_key

export default class example extends Component {

      _getAgoraChannelKey(status){
        // this._loading();
        fetch(CHANNELKEY_URL,{
            method: 'post',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                },
            body: JSON.stringify({
                doctor_id:'NXID00000001',
                patient_id:'NXID00000002'
                })
        }).then( response => {
            return response.json();
        }).then( responseData => {
            if(responseData.code == 0){
                console.log(responseData);
                let channel_data = responseData.data;
                fetch(SIGNALINGKEY_URL,{
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        account:'NXID00000002'
                    }),
                }).then( response => {
                    return response.json();
                }).then( responseData => {
                    // console.log(responseData)
                    if(responseData.code == 0){
                        let data = responseData.data;
                        // this.loginEasemob();
                        console.log("appid",data.app_id);
                        console.log("token",data.token);
                        // console.log('NativeModules',NativeModules.AgoraModule);
                        Viewer.init({
                            remoteName:'张小凡',
                            remoteHeader: TEST_IMAGE_URL + 'doctorDefaultHeader.png',
                            channelKey: channel_data.key,
                            channelName: channel_data.channel_name,
                            appId: data.app_id,
                            callState: status,
                            netStatus: 'wifi',
                            introText: '等待对方接听视频...',
                            videoProfile:50,
                            backgroundImage:TEST_IMAGE_URL + 'v_background.png',
                            hanginImage:TEST_IMAGE_URL + 'v_hangin.png',
                            hangupImage:TEST_IMAGE_URL + 'v_hangupwait.png',
                            muteImage:TEST_IMAGE_URL + 'v_mute.png',
                            unmuteImage:TEST_IMAGE_URL + 'v_unmute.png',
                            switchcameraImage:TEST_IMAGE_URL + 'v_switchcamera.png',
                            hangin:(data)=>{
                                console.log('---1---',data);
                            },
                            hangup:(data)=>{
                                console.log('---2---',data);
                            },
                            hangupIncome:(data)=>{
                                console.log('---3---',data);
                                Viewer.hide();
                            },
                            hangupCalling:(data)=>{
                                console.log('---4---',data);
                                Viewer.hide();
                            },
                            hangupByPeer:(data)=>{
                                console.log('---5---',data);
                            },
                        });
                        Viewer.show();
                    }else{
                        console.log(responseData.msg);
                    }
                }).catch(err=>{
                    console.log(err.toString());
                });
                // this._success(data);
            }else{
            }
        }).catch(err=>{
            console.log(err);
        })
    }


    render() {
        return (
        <View style={styles.container}>
            <TouchableOpacity onPress={()=>{this._getAgoraChannelKey('outPut')}}>
                <Text style={styles.welcome}>
                发起视频
                </Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={()=>{this._getAgoraChannelKey('inCome')}}>
                <Text style={styles.welcome}>
                接收视频
                </Text>
            </TouchableOpacity>
        </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
});

AppRegistry.registerComponent('example', () => example);
