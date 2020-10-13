//
//  CustomText.m
//  adhot-test
//
//  Created by HS on 2020/9/7.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import "CustomText.h"

@implementation CustomText

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    self.text = @"自定义输入框";
}
@end
