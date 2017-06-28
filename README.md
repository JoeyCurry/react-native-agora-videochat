# react-native-agora-videochat

#### 正在开发中...  

进度:安卓视频呼入

[![npm version](https://img.shields.io/npm/v/react-native-agora-videochat.svg?style=flat-square)](https://www.npmjs.com/package/react-native-agora-videochat)

![android视频呼入](./readmeImg/android-inCome.jpeg)

## Getting started

`$ npm install react-native-agora-videochat --save`

### Mostly automatic installation

`$ react-native link react-native-agora-videochat`

### Documentation

#### Params

|Key | Description | Type | Default|
| --- | ----------- | ---- | ------ |
|remoteName  |对方的名称            |string  |''            |
|remoteHeader   |对方的头像地址            |string  |''             |
|channelKey       |声网的channelkey            |string  |''        |
|channelName |声网的channelName           |string   |''   |
|appId  |声网的appid            |string   |''   |
|callState      |呼叫状态(呼入'inCome'/呼出'outPut')            |string   |''   |
|netStatus       |网络状态('wifi'/'')            |string   |'' |
|introText              |呼叫时显示的介绍文字            |string   |'' |
|hangin       |接听视频呼叫            |function|                   |
|hangup        |视频内终止视频            |function|                   |
|hangupIncome        |拒绝视频呼叫            |function|                   |
|hangupCalling        |终止呼叫视频            |function|                   |
|hangupByPeer        |视频内对方终止视频            |function|                   |

#### Methods

|Name | Description | Type | Default|
| --- | ----------- | ---- | ------ |
|init         |init and pass parameters to viewer      |     |   |
|toggle       |show or hide viewer                     |     |   |
|show         |show viewer                             |     |   |
|hide         |hide viewer                             |     |   |
|isViewerShow |get status of viewer, return a boolean  |     |   |

## Usage
```javascript
import Viewer from 'react-native-agora-videochat';

// TODO: What to do with the module?
Viewer.init({
    remoteName:'张小凡',
    remoteHeader: '',
    channelKey: '',
    channelName: '',
    appId: '',
    callState: 'inCome',
    netStatus: 'wifi',
    introText: '邀请你视频',
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
```
  
