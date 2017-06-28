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
  TouchableHighlight
} from 'react-native';
import Viewer from 'react-native-agora-videochat'

const TEST_IMAGE_URL = 'http://images.xingwenpeng.com/'//测试服务器图片地址
const BASE_AGORA_URL = 'http://www.jinma-health.com/agora/'; // 申网接口的base_url
const SIGNALINGKEY_URL = BASE_AGORA_URL + 'signaling_key'; // 登录声网信令所需的signaling_key
const CHANNELKEY_URL = BASE_AGORA_URL + 'channel_key'; // 登录声网信令所需的signaling_key
const UPDATE_RECORD_URL = BASE_AGORA_URL + 'update_record'; // 添加问诊详情消息

export default class example extends Component {

      _getAgoraChannelKey(){
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
                            callState: 'inCome',
                            netStatus: 'wifi',
                            introText: '邀请你视频问诊',
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
                            },
                            hangupByPeer:(data)=>{
                                console.log('---5---',data);
                            },
                        });
                        Viewer.show();
                        // NativeModules.AgoraModule.AgoraSignalLogin(
                        //     data.app_id,
                        //     data.token,
                        //     PatientNxid
                        // );
                        // //有视频呼叫进入时的回调
                        // NativeModules.AgoraModule.AgoraInviteCallback(
                        //     (account,extra)=>{
                        //         console.log('AgoraInviteCallback',account,extra);
                        //         let str = eval('(' + extra + ')'); 
                        //         let value = {
                        //             account,
                        //             orderId:str.orderId
                        //         }
                        //         this.dispatch(videoAction(INCALL,value));
                        //     }
                        // );
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
      <TouchableHighlight onPress={()=>{this._getAgoraChannelKey()}}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
      </TouchableHighlight>
        
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>
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
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('example', () => example);
