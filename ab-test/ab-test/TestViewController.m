//
//  ViewController.m
//  adhot-test
//
//  Created by HS on 2020/9/1.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import "TestViewController.h"
#import "ABVisualConfigManager.h"

@interface TestViewController ()
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)leftTouch:(id)sender {
    
    NSDictionary *abtestData = [self getABTsetData];
    [ABVisualConfigManager configureViewChanges:abtestData];
}


- (IBAction)rightTouch:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSDictionary *viewDict = [ABVisualConfigManager configureControlTree:window];
    NSLog(@"%@",viewDict);
}





















-(NSDictionary *)getABTsetData{
    return @{
        @"changes":@[
            @{
                @"view_id":@[
                    @{
                        @"controllerClass":@"TestViewController",
                        @"controllerIndex":@0
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIButton"
                    }
                ],
                @"properties":@[
                    @{
                        @"name":@"title",
                        @"type":@"text",
                        @"value":@"按钮0"
                    }
                ]
            },
            @{
                @"view_id":@[
                    @{
                        @"controllerClass":@"TestViewController",
                        @"controllerIndex":@0
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@5,
                        @"viewClass":@"CustomView"
                    },
                    @{
                        @"index":@1,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@1,
                        @"viewClass":@"UILabel"
                    }
                ],
                @"properties":@[
                    @{
                        @"name":@"text",
                        @"type":@"text",
                        @"value":@"L1"
                    }
                ]
            },
            @{
                @"view_id":@[
                    @{
                        @"controllerClass":@"TestViewController",
                        @"controllerIndex":@0
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@5,
                        @"viewClass":@"CustomView"
                    },
                    @{
                        @"index":@1,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UILabel"
                    }
                ],
                @"properties":@[
                    @{
                        @"name":@"text",
                        @"type":@"text",
                        @"value":@"L0"
                    }
                ]
            },
            @{
                @"view_id":@[
                    @{
                        @"controllerClass":@"TestViewController",
                        @"controllerIndex":@0
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@5,
                        @"viewClass":@"CustomView"
                    },
                    @{
                        @"index":@1,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@3,
                        @"viewClass":@"UILabel"
                    }
                ],
                @"properties":@[
                    @{
                        @"name":@"textColor",
                        @"type":@"color",
                        @"value":@{
                            @"r":@30,
                            @"g":@177,
                            @"b":@28,
                            @"a":@1
                        }
                    },
                    @{
                        @"name":@"backgroundColor",
                        @"type":@"color",
                        @"value":@{
                            @"r":@52,
                            @"g":@32,
                            @"b":@224,
                            @"a":@1
                        }
                    },
                    @{
                        @"name":@"text",
                        @"type":@"text",
                        @"value":@"L3"
                    }
                ]
            },
            @{
                @"view_id":@[
                    @{
                        @"controllerClass":@"TestViewController",
                        @"controllerIndex":@0
                    },
                    @{
                        @"index":@0,
                        @"viewClass":@"UIView"
                    },
                    @{
                        @"index":@1,
                        @"viewClass":@"UIImageView"
                    }
                ],
                @"properties":@[
                    @{
                        @"name":@"image",
                        @"type":@"image",
                        @"value":@"xcode_png"
                    }
                ]
            }
        ]
    };
}











































-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
//    self.activeView.pg_xpath;
//    self.ac1.pg_xpath;
//    self.ac2.pg_xpath;

//    return;
//
//    self.view.backgroundColor = [UIColor orangeColor];
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//
//    HLView *hlView = [self configureHLView:window];
//
//    NSDictionary *dict = [ModelToJson getObjectData:hlView];
//    NSData *jsonData = [ModelToJson getJSON:hlView options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    //window
    //·contentView
    //··view1
    //··view2
    //·showView
    //··sview1
    //··sview2
    
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//
//    NSDictionary *dict = [ABVisualConfigManager configureABViewDict:window];
//    NSString *jsonStr = [self convertToJsonData:dict];
//    
//    NSLog(@"%@",dict);
//    NSLog(@"%@",jsonStr);
}



-(NSString *)convertToJsonData:(NSDictionary *)dict{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}
































-(void)screenShot{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *imaView = [[UIImageView alloc] initWithImage:image];
    imaView.frame = CGRectMake(0, 100, 37.5, 66.7);
    [self.view addSubview:imaView];

}

@end
