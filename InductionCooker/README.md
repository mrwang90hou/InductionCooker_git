
存在问题：
（1）AdjustView显示后Label的闪现
（2）取消预约的响应不明确
（3）预约的选项个数更改！！！
（4）模式、档位等反应迟钝
（5）segmentControl切换却发生了AdjustView错位
（6）取消预约


（）关机倒计时的bug：2:01
（）定时已关闭的通知！！！
（）CircularProgressBar格式问题！！！






#guofang holyn chen

//Created by mrwang90hou on 2018/7/31
GFTrademark-APP-for-Android
Android项目构建
Record
├──app                              【】
│ ├──manifests                      【】
│ │  └──AndroidManifest.xml         【配置文件，Android应用的入口文件】
│ ├──java(com.holyn.guofang)        【java文件源代码，包名】
│ │  ├──bean                        【毫无价值的东西】
│ │  ├──model                       【(数据)层: 负责获取，保存，缓存以及修改数据】
│ │  ├──presenter                   【Presenter层】
│ │  ├──utils                       【跑龙套】
│ │  ├──view                        【(视图)层：Activities，Fragment以及ViewGroup等在这一层，处理用户的交互和输入事件，并且触发Presenter中的相应操作】
│ │  ├──viewcommon                  【视图控制层】
│ │  ├──zxing                       【扫码登录】
│ │  └──MyApplication
│ └──res                            【资源文件夹】
│    ├──color                       【颜色选择器】
│    ├──drawable                    【可勾画的、可绘制物，APP素材库】
│    ├──layout                      【布局文件汇总库】
│    ├──menu                        【菜单栏设计】
│    ├──mipmap                      【存放launcher icons及动画等，普通图片放drawable，icon图标放mipmap】
│    ├──values                      【存放strings等数值】
│    └──xml                         【xml文件存放数据】
│/************************************/
├──mylibrary                        【】
├──pageindicatorview                【】
├──RxTools-library                  【】
└──Gradle Scripts                           【Gradle脚本】
├──build.gradle(Project:guofang)          【Project的配置文件，可以配置版本，插件，依赖库等等的信息，比较常见的就是Jcenter仓库的配置】
├──build.gradle(Module:app)               【Module配置文件:默认配置，构建/打包版本，依赖关系(三方框架)】
├──build.gradle(Module:mylibrary)         【】
├──build.gradle(Module:pageindicatorview) 【】
├──build.gradle(Module:RxTools-library)   【】
├──gradle.properties                      【配置文件，可在gradle文件里直接引用】
├──gradle-wrapper.properties              【gradle版本及下载地址】
├──local.properties                       【系统配置：sdk路径、ndk路径，亦可放入自定义的配置：签名文件等】
├──progusrd-rules.pro                     【ProGuard规则】
└──settings.gradle(Project Settings)      【子项目（Module）的配置文件】


Project目录框架:
guofang
├──.gradle                      【gradle版本】
├──.idea                        【】
├──app                          【】
├──barlibrary                   【沉浸式-状态栏和导航栏】
├──bottom-bar                   【底栏】
├──build                        【】
├──cropiwa_library              【适用于Android的可配置自定义裁剪小部件】
├──gradle                       【】
├──mylibrary                    【我的文库-加载设计方案】
├──navigationtabstrip           【选项卡导航条】
├──pageindicatorview            【页面指示器视图】
├──picture_library              【照片库】
├──popupwindow-lib              【弹窗库】
├──recyclerviewadapterlibrary   【通用适配器库】
├──rxdownload                   【基于RxJava打造的下载工具, 支持多线程和断点续传】
└──RxTools-library              【Rx工具-库【开发人员不得不收集的工具类集合 | 支付宝支付 | 微信支付（统一下单） | 微信分享 | Zip4j压缩（支持分卷压缩与加密） | 一键集成UCrop选择圆形头像 | 一键集成二维码和条形码的扫描与生成 | 常用Dialog | WebView的封装可播放视频 | 仿斗鱼滑动验证码 | Toast封装 | 震动 | GPS | Location定位 | 图片缩放 | Exif 图片添加地理位置信息（经纬度） | 蛛网等级 | 颜色选择器 | ArcGis | VTPK | 编译运行一下说不定会找到惊喜】https://github.com/vondear/RxTool/wiki/RxTool-Wiki】



版本构建：

内网版本（绿色）
applicationId "com.holyn.guofang1"             普通识别/查询
applicationId "com.holyn.guofang1_plus"        高级识别/查询

外网版本（蓝色）
applicationId "com.holyn.guofang2"             普通识别/查询
applicationId "com.holyn.guofang2_plus"        高级识别/查询

版本命名规则:（四个版本随着根版本build随时更替）
商标识别手build1
商标识别手build2
商标识别手build3



项目结构：

GFTrademark-APP
├──资源文件（图片、文件、SQL数据、字符串等）
│ ├──images图片
│ ├──SQLite数据
│ └──strings字符串
│
├──故事板（空）
│
├──基类
│ ├──主视图控制器:GFBaseViewController    Created by 夏伟耀 on 16/2/26
│【导航栏模块】
│ ├──主要构架                
│ │ ├──登录                Created by 夏伟耀 on 16/2/26.
│ │ ├──登录验证                Created by 夏伟耀 on 16/7/30.
│ │ ├──注册                Created by 夏伟耀 on 16/7/26.
│ │ ├──找回密码                Created by 夏伟耀 on 16/7/28.
│ │ ├──服务条款                Created by 梁梓龙 on 16/3/8.
│ │ ├──主要TabBar            Created by 梁梓龙 on 16/3/23.
│ │ └──欢迎界面                Created by 梁家安 on 17/7/4.
│ ├──商标识别（第一栏）
│ │ ├──识别home设置            Created by 梁梓龙 on 16/3/11.
│ │ ├──普通识别查询            Created by 梁家安 on 17/2/13.
│ │ │ ├──
│ │ │ └──
│ │ ├──高级识别查询            Created by 梁家安 on 17/2/21.
│ │ │ ├──
│ │ │ └──
│ │ ├──剪裁[xib设计]            Created by 梁梓龙 on 16/3/17.
│ │ ├──分拆组合                Created by 梁梓龙 on 16/3/29.
│ │ ├──结合预览                Created by 梁梓龙 on 16/4/5.
│ │ ├──替换追加                Created by 梁梓龙 on 16/4/13.    Created by 梁梓龙 on 16/4/14.
│ │ ├──添加查询方式            Created by 夏伟耀 on 16/4/12.
│ │ ├──展示图片                Created by 梁家安 on 17/3/7.
│ │ ├──准备                Created by 梁梓龙 on 16/3/24.        
│ │ └──近似商标图样            Created by 梁梓龙 on 16/4/12.
│ ├──商标查询（第二栏）
│ │ ├── 查询home设置            Created by 夏伟耀 on 16/4/19.
│ │ └──高级查询                Created by 梁梓龙 on 16/4/20.
│ ├──商标服务（第三栏）
│ │ ├── WebServiceView            Created by 夏伟耀 on 16/4/21.
│ │ └──商标在线代理            Created by 夏伟耀 on 16/4/21.
│ └──我的（第四栏）
│ │ ├──MyView                Created by 夏伟耀 on 16/4/22.
│ │ ├──进程处理                Created by 夏伟耀 on 16/4/23.
│ │ ├──注册信息                Created by 夏伟耀 on 16/4/25.
│ │ ├──替换主设备                Created by 梁家安 on 2017/6/8.
│ │ ├──修改密码                Created by 夏伟耀 on 16/4/25.
│ │ ├──用卡管理                Created by 夏伟耀 on 16/4/25.
│ │ ├──购国方卡                Created by 梁家安 on 17/6/13.
│ │ ├──我的订单                Created by 梁家安 on 17/6/27.
│ │ ├──使用日志                Created by 夏伟耀 on 16/4/26.
│ │ ├──注销当前用户            Created by 夏伟耀 on 16/4/22. ->GFMyViewController.m
│ │ └──【我的通知】新增            Created by 王 宁 on 18/1/22.
│【功能模块】
│ ├──苹果支付                Created by 梁家安 on 17/6/16.
│ ├──图像要素                Created by 夏伟耀 on 16/4/13.
│ ├──商品范围                Created by 夏伟耀 on 16/3/17.
│ ├──搜索算法                【多人合作】
│ └──结果展示
│
├──数据导入样式
│
├──数据导出样式
│
├──网络请求                Created by 梁梓龙 on 15/11/24.    Created by 夏伟耀 on 16/7/25.
│
├──数据库服务                Created by 夏伟耀 on 16/2/26.
│
├──自定义视图
│
├──工具类
│ └──常用宏（服务器、颜色、屏幕尺寸等）
│ 
├──AppDelegate项目启动代理（launch图片）    Created by 夏伟耀 on 16/2/24.
│ └──AppDelegate+AppService 处理生命周期之外的业务
│
└───配置文件info.plist

三方框架
Pods              
├──AFNetworking                   【网络请求框架】
├──CocoaLumberjack            【Log日志库-企业级日志框架】支持日志打印到Xcode控制台，打印到mac的console程序、打印到文件
├──DACircularProgress          【环形进度条框架-圆形进度视图】具有UIProgressView属性
├──DateTools                         【日期工具库】
├──HMSegmentedControl     【分段控制器】
├──IQKeyboardManager        【键盘处理神器】
├──Masonry                            【纯代码布局框架】
├──MJExtension                      【转换速度快、使用简单方便的字典转模型框架】
├──MBProgressHUD              【Toast提示控件】
├──MJRefresh                        【上下拉刷新加载控件】
├──MobileVLCKit                   【全平台播放器】
├──MWPhotoBrowser            【图片浏览库】
├──SDWebImage                   【网络及本地图片的异步加载及缓存】
├──SVProgressHUD              【进度显示框架】
├──UAProgressView              【圆形加载进程动画】
├──UMCAnalytics                 【分析】
├──UMCCommon                 【友盟组件化SDK基础库】
└──UMCSecurityPlugins       【安全组件:为开发者提供安全的数据环境，能有效的防止刷量和反作弊等行为】


苹果开发者账号：103730638@qq.com
密码：Goockr86678686
p12证书密码:goockr
Apple ID ： i17666167557@icloud.com
公司苹果开发者账户：goockr@126.com   密码：Goockr86
Wifi:gktest
密码:goockr86


