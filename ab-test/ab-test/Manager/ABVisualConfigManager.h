//
//  ABVisualConfigManager.h
//  adhot-test
//
//  Created by HS on 2020/10/10.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NSString * HLABTestViewOptionKey NS_STRING_ENUM;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyType;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyTop;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyLeft;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyWidth;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyHeight;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyProperties;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyChildren;
extern HLABTestViewOptionKey const HLABTestViewOptionKeyViewID;


@interface ABVisualConfigManager : NSObject

//应用试验修改信息
+(void)configureViewChanges:(NSDictionary *)dict;
//生成控件树信息
+(NSDictionary<HLABTestViewOptionKey , id> *)configureControlTree:(UIView *)view;

@end

