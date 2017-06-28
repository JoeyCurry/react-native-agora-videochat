import {
    Platform,
    NativeModules,
    NativeAppEventEmitter
} from 'react-native';

let ios = Platform.OS === 'ios';
let android = Platform.OS === 'android';
let Viewer = NativeModules.CommunicationView;

export default {

    init(options){
        let opt = {
            remoteName: '',
            remoteHeader: '',
            channelKey: '',
            channelName: '',
            appId: '',
            callState: '',
            netStatus: '',
            introText: '',
            hangin(){},
            hangup(){},
            hangupIncome(){},
            hangupCalling(){},
            hangupByPeer(){},
            ...options
        };
        let fnConf = {
            hangupIncome: opt.hangupIncome,
            hangupCalling: opt.hangupCalling,
            hangin: opt.hangin,
            hangup:opt.hangup,
            hangupByPeer:opt.hangupByPeer
        };
        Viewer._init(opt);
        //there are no `removeListener` for NativeAppEventEmitter & DeviceEventEmitter
        this.listener && this.listener.remove();
        this.listener = NativeAppEventEmitter.addListener('viewEvent', event => {
            fnConf[event['type']](event['status']);
        });
    },

    show(){
        Viewer.show();
    },

    hide(){
        Viewer.hide();
    },

    toggle(){
        this.isViewerShow(show => {
            if(show){
                this.hide();
            }
            else{
                this.show();
            }
        });
    },

    isViewerShow(fn){
        //android return two params: err(error massage) and status(show or not)
        //ios return only one param: hide or not...
        Picker.isViewerShow((err, status) => {
            let returnValue = null;
            if(android){
                returnValue = err ? false : status;
            }
            else if(ios){
                returnValue = err;
            }
            fn(returnValue);
        });
    }
};