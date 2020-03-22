//
//  HJQHanXinKuGenerate.h
//  HJQHanXinKuGenerate
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 Mrhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJQHanXinKuGenerate : NSObject


/**
 inputText:输入文本
 */
+ (NSString *)jq_hanXinEncodeInputText:(NSString *)inputText;

+ (NSString *)jq_hanXinEncodeInputText2:(const char *)inputText;


@end
