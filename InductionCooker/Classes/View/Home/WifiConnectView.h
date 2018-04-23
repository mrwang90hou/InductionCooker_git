//
//  WifiConnectView.h
//  InductionCooker
//
//  Created by csl on 2017/11/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiConnectView : UIView

typedef NS_ENUM(NSInteger, WifiConnectType) {
    WifiConnectTypeDisconnect = 0,
      WifiConnectTypeConnecting=1,
     WifiConnectTypeConnected=2
};

//- (void) setWifiConnectType:(WifiConnectType) type;

- (void) setWifiConnectLabelTitleWithIndex:(int) status;
@end
