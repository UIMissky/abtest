//
//  CustomView.m
//  adhot-test
//
//  Created by HS on 2020/9/7.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import "CustomView.h"
#import "CustomText.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
    
    CustomText *text1 = [CustomText new];
    text1.backgroundColor = [UIColor greenColor];
    text1.frame = self.frame;
    [self addSubview:text1];
    
    text1.text = @"111";
}
@end
