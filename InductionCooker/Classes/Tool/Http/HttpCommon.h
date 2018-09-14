//
//  HttpCommon.h
//  InductionCooker
//
//  Created by csl on 2017/8/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#ifndef HttpCommon_h
#define HttpCommon_h

//http://120.24.5.252:8099/cooker/servlet/AppServlet?functype=vc&mobile=13763085121

#define KHttpHeader                                 @"http://www.zhuhaiheyi.com"//@"http://120.24.5.252:8099"
//#define KHttpHeader                                 @"http://106.12.17.94:8080"//@"http://120.24.5.252:8099"

#define KHttpLoginSmsCode                           @"/cooker/servlet/AppServlet"///mask/servlet/AppServlet

#define KHttpLoginPwd                               @"/cooker/servlet/AppServlet"///mask/servlet/AppServlet

#define KHttpLoginSmsCode                           @"/cooker/servlet/AppServlet"

#define KHttpForgetSmsCode                          @"/cooker/servlet/AppServlet"

#define KHttpRegistSmsCode                          @"/cooker/servlet/AppServlet"

#define KHttpSmsLogin                               @"/cooker/servlet/AppServlet"

#define KHttpForgetPwd                              @"/cooker/servlet/AppServlet"

#define KHttpBeforeRegist                           @"/cooker/servlet/AppServlet"

#define KHttpRegist                                 @"/cooker/servlet/AppServlet"

#define KHttpResetPwd                               @"/cooker/servlet/AppServlet"



#define KHttpDeviceChangeUser                       @"/cooker/servlet/AppServlet"

#define KHttpDeviceChangeUserSmsCode                @"/cooker/servlet/AppServlet"

#define KHttpBindingDevice                          @"/cooker/api/saveDeviceRef"
///cooker/api/findAppRef
#define KHttpDeviceList                             @"/cooker/api/findAppRef"

#define KHttpFindSelectDev                          @"/cooker/api/findAppDefaultRef"

#define KHttpChangeSelectDev                        @"/cooker/api/chgDeviceRef"

#define KHttDelDeviceRef                            @"/cooker/a/comm/commDeviceRef/delDeviceRef"

#endif /* HttpCommon_h */






























