
import {AppRegistry} from 'react-native';
import React, {
    Component
} from 'react';
import PropTypes from 'prop-types';
import HistoryNavigationbar from './DYHotUpdateApp/DYHotUpdateProject/appHot/HistoryNavigationbar';
import MyAttentionList from './DYHotUpdateApp/DYHotUpdateProject/appHot/MyAttentionList';
if (!__DEV__) {
    global.Console = {
        info: () => {
        },
        log: () => {
        },
        warn: () => {
        },
        debug: () => {
        },
        error: () => {
        },
    };
}
console.ignoredYellowBox = ['Remote debugger','RCTBatchedBrige is'];
AppRegistry.registerComponent('HelloWorldApp', () => HistoryNavigationbar);


class RouterPage extends Component {
    static propTypes = {
        scence:PropTypes.string,
    };
    static defaultProps = {
        scence: 'HistoryNavigationbar',
    };
    renderScene = (scence) => {
        switch (scence) {
        case 'HistoryNavigationbar':
            return  <HistoryNavigationbar/>;
            break;
        case 'MyAttentionList':


            
            return  <MyAttentionList/>;
            break;
        default:
            return <HistoryNavigationbar/>;
        }
    }
    render() {
        return this.renderScene(this.props.scence);
    }
}
//IOS统一入口通过RouterPage选择加载的模块
AppRegistry.registerComponent('RouterPage', () => RouterPage);

