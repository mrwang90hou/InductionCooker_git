//
//  RHSocketConfig.h
//  iOSMp3Recorder
//
//  Created by csl on 2017/2/18.
//  Copyright © 2017年 xiaoxuan Tang. All rights reserved.
//

#ifndef RHSocketConfig_h
#define RHSocketConfig_h

#ifdef DEBUG
#define RHSocketDebug
#endif

#ifdef RHSocketDebug
#define RHSocketLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define RHSocketLog(format, ...)
#endif


#endif /* RHSocketConfig_h */
