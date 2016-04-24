# WeatherElf
##一个使用Objective-C实现的天气预报APP

###简介
* 天气API来自百度[天气查询－车联网API](http://lbsyun.baidu.com/index.php?title=car/api/weather)
* 用Storyboard+Xib+Autolayout的方式来实现UI部分,方便快捷
* 使用CocoaPods管理用到的第三方库

###屏幕截屏
<img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/beijing.png" width = "375" height = "667" alt="beijing" align=center />

<img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/xiamen.png" width = "375" height = "667" alt="xiamen" align=center /><img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/hangzhou.png" width = "375" height = "667" alt="hangzhou" align=center />
<img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/shanghai.png" width = "375" height = "667" alt="shanghai" align=center /><img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/shenzhen.png" width = "375" height = "667" alt="shenzhen" align=center />
<img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/guangzhou.png" width = "375" height = "667" alt="guangzhou" align=center /><img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/xian.png" width = "375" height = "667" alt="xian" align=center />
<img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/location.png" width = "375" height = "667" alt="location" align=center /><img src="https://github.com/newHopeLJP/WeatherElf/blob/master/Screenshots/selectcity.png" width = "375" height = "667" alt="selectcity" align=center />
###已实现功能
* 显示当天以及未来3天的天气情况以及生活指数情况
* 根据当前的空气质量自动改变界面背景
* 手动刷新当天实时天气情况
* 初步定位功能，默认显示定位所在地的天气情况
* 初步地址管理功能，用户自行配置要显示的一个或多个城市
* 可以同时显示多个地方的天气预报情况，通过左右滑动切换定制的城市

###待添加功能
* 显示更加详细的一天的天气变化曲线
* 加入出行提醒功能（主要包括出发地和目的地的天气情况），做好出行准备
* 定位功能完善，如定位失败时提示手动添加地址
* 地址管理功能完善，目前只能添加，不能删除，也没有持久化
* 增加分享功能

###存在问题
* 目前API返回的天气图片风格与当前界面风格不一致，需要自行映射一套匹配的图片

###适配
* iOS 9.0+
* Xcode 7.2
* 其他环境下未调试过，具体情况未知

###用到的第三方库
* SDWebImage
* MJRefresh

###Licence
* MIT
