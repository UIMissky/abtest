//
//  ABVisualConfigManager.m
//  adhot-test
//
//  Created by HS on 2020/10/10.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import "ABVisualConfigManager.h"


HLABTestViewOptionKey const HLABTestViewOptionKeyType           = @"type";
HLABTestViewOptionKey const HLABTestViewOptionKeyTop            = @"top";
HLABTestViewOptionKey const HLABTestViewOptionKeyLeft           = @"left";
HLABTestViewOptionKey const HLABTestViewOptionKeyWidth          = @"width";
HLABTestViewOptionKey const HLABTestViewOptionKeyHeight         = @"height";
HLABTestViewOptionKey const HLABTestViewOptionKeyProperties     = @"properties";
HLABTestViewOptionKey const HLABTestViewOptionKeyChildren       = @"children";
HLABTestViewOptionKey const HLABTestViewOptionKeyViewID         = @"view_id";


@implementation ABVisualConfigManager

#pragma mark - 生成控件树信息

+(NSDictionary<HLABTestViewOptionKey , id> *)configureControlTree:(UIView *)view{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect= [view convertRect:view.bounds toView:window];
    
    NSString *type = NSStringFromClass(view.class);
    NSNumber *top = [NSNumber numberWithFloat:rect.origin.y];
    NSNumber *left = [NSNumber numberWithFloat:rect.origin.x];
    NSNumber *width = [NSNumber numberWithFloat:view.bounds.size.width];
    NSNumber *height = [NSNumber numberWithFloat:view.bounds.size.height];
    NSMutableArray *view_id = [NSMutableArray array];
    NSMutableArray *properties = [NSMutableArray array];
    NSMutableArray *children = [NSMutableArray array];
    
    //view_id
    UIViewController *currentVC = [self currentViewController];
    UIView *currentView = view;
    while (1) {
        if (currentView.superview == nil) {
            [view_id insertObject:@{@"index":@0,
                                    @"viewClass":NSStringFromClass(currentView.class)}
                          atIndex:0];
            break;
        }
        
        NSNumber *viewIndex = [NSNumber numberWithInteger:[currentView.superview.subviews indexOfObject:currentView]];
        [view_id insertObject:@{@"index":viewIndex,
                                @"viewClass":NSStringFromClass(currentView.class)}
        atIndex:0];
        
        if ([currentVC.view isEqual:currentView]) {
            [view_id insertObject:@{@"controllerIndex":@0,
                                    @"controllerClass":NSStringFromClass(currentVC.class)}
                          atIndex:0];
            break;
        }
        
        currentView = currentView.superview;
    }
    NSLog(@"%@",view_id);
    
    //properties
    [properties addObject:[self configureViewPropertieInfoName:@"hidden" type:@"boolean" info:@(view.isHidden)]];
    [properties addObject:[self configureViewPropertieInfoName:@"alpha" type:@"float" info:[NSNumber numberWithFloat:view.alpha]]];
    [properties addObject:[self configureViewPropertieInfoName:@"backgroundColor" type:@"color" info:[self configureColorProperty:view.backgroundColor]]];
    [properties addObject:[self configureViewPropertieInfoName:@"userInteractionEnabled" type:@"boolean" info:@(view.userInteractionEnabled)]];
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [properties addObject:[self configureViewPropertieInfoName:@"title" type:@"text" info:btn.titleLabel.text]];
        [properties addObject:[self configureViewPropertieInfoName:@"titleColor" type:@"color" info:[self configureColorProperty:btn.titleLabel.textColor]]];
    }
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        [properties addObject:[self configureViewPropertieInfoName:@"text" type:@"text" info:label.text]];
        [properties addObject:[self configureViewPropertieInfoName:@"textColor" type:@"color" info:[self configureColorProperty:label.textColor]]];
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        [properties addObject:[self configureViewPropertieInfoName:@"image" type:@"image" info:@""]];
    }

    //children
    if (view.subviews.count) {
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [children addObject:[self configureControlTree:obj]];
        }];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:type forKey:HLABTestViewOptionKeyType];
    [dict setValue:top forKey:HLABTestViewOptionKeyTop];
    [dict setValue:left forKey:HLABTestViewOptionKeyLeft];
    [dict setValue:width forKey:HLABTestViewOptionKeyWidth];
    [dict setValue:height forKey:HLABTestViewOptionKeyHeight];
    [dict setValue:properties forKey:HLABTestViewOptionKeyProperties];
    [dict setValue:children forKey:HLABTestViewOptionKeyChildren];
    [dict setValue:view_id forKey:HLABTestViewOptionKeyViewID];
    
    return [dict copy];
}

+(NSDictionary *)configureViewPropertieInfoName:(NSString *)name type:(NSString *)type info:(id)info{
    return [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",type,@"type,",info,@"value",nil];
}

+(NSDictionary *)configureColorProperty:(UIColor *)color{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @{
        @"r":[NSNumber numberWithFloat:red *255.0],
        @"g":[NSNumber numberWithFloat:green *255.0],
        @"b":[NSNumber numberWithFloat:blue *255.0],
        @"a":[NSNumber numberWithFloat:alpha],
    };
}




#pragma mark - 应用试验修改信息

+(void)configureViewChanges:(NSDictionary *)dict{

    NSArray<NSDictionary *> *changes = dict[@"changes"];
    [changes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self configureViewChange:obj];
        
    }];
}

+(void)configureViewChange:(NSDictionary *)change{
    
    //当前展示的控制器是否和change-controllerClass匹配
    UIViewController *currentVC = [self currentViewController];
    NSString *controllerClass = [[[change objectForKey:@"view_id"] firstObject] objectForKey:@"controllerClass"];
    if (![NSStringFromClass(currentVC.class) isEqualToString:controllerClass]) {
        return;
    }
    
    //根据view_id 获取到view
    NSArray<NSDictionary *> *view_id = [change objectForKey:@"view_id"];
    __block UIView *view = nil;
    [view_id enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx == 0) {
        }else if (idx == 1){
            view = currentVC.view;
        }else{
            view = [view.subviews objectAtIndex:[[obj objectForKey:@"index"] integerValue]];
        }
    }];
    
    //view应用属性修改
    NSArray<NSDictionary *> *properties = [change objectForKey:@"properties"];
    [properties enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        //枚举不同类型的type,生产对应类型的value
        NSString *type = [obj objectForKey:@"type"];
        id value = nil;
        if ([type isEqualToString:@"text"]) {
            value = (NSString *)[obj objectForKey:@"value"];
        }else if ([type isEqualToString:@"color"]){
            value = [UIColor colorWithRed:[[[obj valueForKey:@"value"] objectForKey:@"r"] floatValue]/255.0
                                    green:[[[obj valueForKey:@"value"] objectForKey:@"g"] floatValue]/255.0
                                     blue:[[[obj valueForKey:@"value"] objectForKey:@"b"] floatValue]/255.0
                                    alpha:[[[obj valueForKey:@"value"] objectForKey:@"a"] floatValue]];
        }else if ([type isEqualToString:@"image"]){
            value = (NSString *)[obj objectForKey:@"value"];
        }
        
        //枚举不同类型的name,调用View不同的方法
        NSString *name = [obj objectForKey:@"name"];
        if ([name isEqualToString:@"text"]) {
            
            if ([view isKindOfClass:UILabel.class]) {
                UILabel *label = (UILabel *)view;
                [label setText:value];
            }
            
        }else if ([name isEqualToString:@"textColor"]){
            
            if ([view isKindOfClass:UILabel.class]) {
                UILabel *label = (UILabel *)view;
                [label setTextColor:value];
            }
            
        }else if ([name isEqualToString:@"title"]){
            
            if ([view isKindOfClass:UIButton.class]) {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:value forState:UIControlStateNormal];
            }
            
        }else if ([name isEqualToString:@"titleColor"]){
            
            if ([view isKindOfClass:UIButton.class]) {
                UIButton *btn = (UIButton *)view;
                [btn setTitleColor:value forState:UIControlStateNormal];
            }
            
        }else if ([name isEqualToString:@"image"]){
            //TODO SD_WebImageViewLoadURLImage
            if ([view isKindOfClass:UIImageView.class]) {
                UIImageView *imageView = (UIImageView *)view;
                [imageView setImage:[UIImage imageNamed:value]];
            }
            
        }else if ([name isEqualToString:@"backgroundColor"]){
            
            [view setBackgroundColor:value];
    
        }
    }];
    
}

+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}























@end
